//
//  ExchangeSearchBarViewModel.swift
//  CryptocurrencyTests
//
//  Created by Seungjin Baek on 2022/01/22.
//

import XCTest
@testable import Cryptocurrency

import Nimble
import RxNimble
import RxSwift
import RxTest

class ExchangeSearchBarViewModelTests: XCTestCase {
  
  var sut: ExchangeSearchBarViewModel!
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!
  
  
  // MARK: Settings
  
  override func setUp() {
    self.sut = ExchangeSearchBarViewModel()
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    self.disposeBag = DisposeBag()
  }
  
  
  // MARK: Tests
  
  func test_검색_바에_입력된_문자열이_없는_경우_모든_OrderCurrency_딕셔너리를_반환() throws {
    //given
    let expectedResult = OrderCurrency.orderCurrencyDictionaryByTicker

    //when
    self.scheduler.createColdObservable(
      [
        .next(5, "")
      ]
    ).bind(to: self.sut.inputText)
      .disposed(by: self.disposeBag)

    //then
    expect(self.sut.orderCurrenciesToSearch)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(5, expectedResult)
        ]
      ))
  }
  
  func test_검색_바에_입력된_문자열이_있는_경우_매칭된_OrderCurrency_딕셔너리를_반환() throws {
    //given
    let keyword = "BT"
    let expectedResult = OrderCurrency.filteredCurrencies(with: keyword)

    //when
    self.scheduler.createColdObservable(
      [
        .next(5, keyword)
      ]
    ).bind(to: self.sut.inputText)
      .disposed(by: self.disposeBag)
    
    //then
    expect(self.sut.orderCurrenciesToSearch)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(5, expectedResult)
        ]
      ))
  }
}
