//
//  ExchangeViewModelTests.swift
//  BithumbTests
//
//  Created by Seungjin Baek on 2022/01/25.
//

import XCTest
@testable import Bithumb

import Nimble
import RxNimble
import RxSwift
import RxTest

class ExchangeViewModelTests: XCTestCase {
  
  var sut: ExchangeViewModel!
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!
  
  
  // MARK: Settings
  
  override func setUp() {
    let responseStub: Result<AllTickerResponse, BithumbNetworkError> = .success(AllTickerResponse(
      status: "0000",
      data: [
        "BTC": TickerData(
          openingPrice: "1000",
          closingPrice: "2000",
          minPrice: "3000",
          maxPrice: "4000",
          tradedUnit: "5000",
          accTradeValue: "6000",
          previousClosingPrice: "7000",
          tradedUnit24H: "8000",
          accTradeValue24H: "9000",
          fluctate24H: "10000",
          fluctateRate24H: "1.0",
          date: nil
        )
      ]
    ))
    self.sut = ExchangeViewModel(useCase: ExchangeUseCaseSpy(tickerResponseStub: responseStub))
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    self.disposeBag = DisposeBag()
  }
  
  
  // MARK: Tests
  
  func test_SearchBar에서_검색을_했을_때_CoinListViewModel로_CellData가_전달되는_지_확인() throws {
    //given
    let expectedResult = [CoinListViewCellData(
      coinName: "비트코인",
      ticker: "BTC",
      currentPrice: "2000",
      priceChangedRatio: "1.0",
      priceDifference: "10000",
      transactionAmount: "9000"
    )]

    //when
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
