//
//  ExchangeViewModelTests.swift
//  CryptocurrencyTests
//
//  Created by Seungjin Baek on 2022/01/25.
//

import XCTest
@testable import Cryptocurrency

import Nimble
import RxNimble
import RxSwift
import RxTest

class ExchangeViewModelTests: XCTestCase {
  
  var sut: ExchangeViewModel!
  var exchangeUseCase: ExchangeUseCaseSpy!
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!
  
  
  // MARK: Settings
  
  override func setUp() {
    self.exchangeUseCase = ExchangeUseCaseSpy()
    self.sut = ExchangeViewModel(useCase: self.exchangeUseCase)
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    self.disposeBag = DisposeBag()
  }
  
  
  // MARK: Tests

  func test_검색어에_문자가_입력될_경우_OrderCurrency_타입으로_변환_여부_확인() {
    //when
    self.scheduler.createColdObservable(
      [
        .next(5, "BTC")
      ]
    ).bind(to: self.sut.exchangeSearchBarViewModel.inputText)
      .disposed(by: self.disposeBag)

    //then
    expect(self.sut.exchangeSearchBarViewModel.orderCurrenciesToSearch)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(5, [OrderCurrency.btc : "BTC"])
        ]
      ))
  }
  
  func test_SearchBar에서_검색을_했을_때_CoinListViewModel로_CellData가_전달되는_지_확인() throws {
    //given
    self.exchangeUseCase.coinListCellDataStub = [
      CoinListViewCellData(
        coinName: "이더리움",
        ticker: "ETH",
        currentPrice: "2000",
        priceChangedRatio: "1.0",
        priceDifference: "10000",
        transactionAmount: "9000"
      ),
      CoinListViewCellData(
        coinName: "비트코인",
        ticker: "BTC",
        currentPrice: "2000",
        priceChangedRatio: "1.0",
        priceDifference: "10000",
        transactionAmount: "9000"
      )
    ]
    self.exchangeUseCase.sortedByTransactionAmountStub = self.exchangeUseCase.coinListCellDataStub

    let expectedResult = [
      CoinListViewCellData(
        coinName: "비트코인",
        ticker: "BTC",
        currentPrice: "2000",
        priceChangedRatio: "1.0",
        priceDifference: "10000",
        transactionAmount: "9000"
      )
    ]

    //when
    self.scheduler.createColdObservable(
      [
        .next(4, (isDescending: true, coinListSortCriterion: .transactionAmount))
      ]
    ).bind(to: self.sut.coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)

    self.scheduler.createColdObservable(
      [
        .next(5, "BTC")
      ]
    ).bind(to: self.sut.exchangeSearchBarViewModel.inputText)
      .disposed(by: self.disposeBag)
    
    //then
    expect(self.sut.coinListViewModel.coinListCellData)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(5, expectedResult)
        ]
      ))
  }
}
