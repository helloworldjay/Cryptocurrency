//
//  PriceChangedPeriodViewModelTests.swift
//  BithumbTests
//
//  Created by 이영우 on 2022/01/24.
//

import XCTest
@testable import Bithumb

import Nimble
import RxNimble
import RxSwift
import RxTest

final class PriceChangedPeriodViewModelTests: XCTestCase {
  
  var sut: PriceChangedPeriodViewModel!
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!
  
  
  // MARK: Settings
  
  override func setUp() {
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    self.disposeBag = DisposeBag()
  }
  
  
  // MARK: Tests
  
  func test_어제_대비였을_때_24시간을_누르는_경우() throws {
    //given
    self.sut = PriceChangedPeriodViewModel(selectedPeriod: .yesterday)

    //when
    self.scheduler.createColdObservable(
      [
        .next(5, IndexPath(row: 1, section: .zero))
      ]
    ).bind(to: self.sut.tapListView)
      .disposed(by: self.disposeBag)

    //then
    expect(self.sut.selectedPeriod)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(0, Period.yesterday),
          .next(5, Period.twentyFourHour)
        ]
      ))
  }
  
  func test_24시간였을_때_한_시간을_누르는_경우() throws {
    //given
    self.sut = PriceChangedPeriodViewModel(selectedPeriod: .twentyFourHour)
    
    //when
    self.scheduler.createColdObservable(
      [
        .next(5, IndexPath(row: 3, section: .zero))
      ]
    ).bind(to: self.sut.tapListView)
      .disposed(by: self.disposeBag)

    //then
    expect(self.sut.selectedPeriod)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(0, Period.twentyFourHour),
          .next(5, Period.oneHour)
        ]
      ))
  }
  
  func test_12시간였을_때_30분을_누르는_경우() throws {
    //given
    self.sut = PriceChangedPeriodViewModel(selectedPeriod: .twelveHour)
    
    //when
    self.scheduler.createColdObservable(
      [
        .next(5, IndexPath(row: 4, section: .zero))
      ]
    ).bind(to: self.sut.tapListView)
      .disposed(by: self.disposeBag)

    //then
    expect(self.sut.selectedPeriod)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(0, Period.twelveHour),
          .next(5, Period.thirtyMinute)
        ]
      ))
  }
}
