//
//  ExchangeSearchBarViewModel.swift
//  BithumbTests
//
//  Created by Seungjin Baek on 2022/01/22.
//

import XCTest
@testable import Bithumb

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
  
  func test_검색_버튼을_눌렀을_때_입력된_문자열이_없는_경우() throws {
    //given
    self.scheduler.createColdObservable(
      [
        .next(5, "")
      ]
    ).bind(to: self.sut.inputText)
      .disposed(by: self.disposeBag)
    
    //when
    self.scheduler.createColdObservable(
      [
        .next(10, ())
      ]
    ).bind(to: self.sut.searchButtonTapped)
      .disposed(by: self.disposeBag)
    
    //then
    expect(self.sut.orderCurrencyToSearch)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(10, OrderCurrency.all)
        ]
      ))
  }
  
  func test_검색_버튼을_눌렀을_때_입력된_문자열이_있는_경우() throws {
    //given
    let keyword = "ALL"
    self.scheduler.createColdObservable(
      [
        .next(5, keyword)
      ]
    ).bind(to: self.sut.inputText)
      .disposed(by: self.disposeBag)
    
    //when
    self.scheduler.createColdObservable(
      [
        .next(10, ())
      ]
    ).bind(to: self.sut.searchButtonTapped)
      .disposed(by: self.disposeBag)
    
    //then
    expect(self.sut.orderCurrencyToSearch)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(10, OrderCurrency.all)
        ]
      ))
  }
  
  func test_검색_버튼을_다시_눌렀을_때_입력된_문자열이_기존의_입력과_같은_경우() throws {
    //given
    let keyword = "ALL"
    self.scheduler.createColdObservable(
      [
        .next(5, keyword),
        .next(10, keyword)
      ]
    ).bind(to: self.sut.inputText)
      .disposed(by: self.disposeBag)
    
    //when
    self.scheduler.createColdObservable(
      [
        .next(6, ()),
        .next(11, ())
      ]
    ).bind(to: self.sut.searchButtonTapped)
      .disposed(by: self.disposeBag)
    
    //then
    expect(self.sut.orderCurrencyToSearch)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(6, OrderCurrency.all)
        ]
      ))
  }
}
