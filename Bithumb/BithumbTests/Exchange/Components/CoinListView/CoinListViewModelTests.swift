//
//  CoinListViewModelTests.swift
//  BithumbTests
//
//  Created by Seungjin Baek on 2022/02/05.
//

import XCTest
@testable import Bithumb

import Nimble
import RxNimble
import RxSwift
import RxTest

class CoinListViewModelTests: XCTestCase {

  var sut: CoinListViewModelLogic!
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  override func setUp() {
    self.sut = CoinListViewModel()
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }

  override func tearDown() {
    self.disposeBag = DisposeBag()
  }

  func test_socket_통신으로_문자열이_들어올_경우_전처리_및_디코딩_확인() {
    //given
    let socketText =
"""
 {\"type\":\"ticker\",\"content\":{\"tickType\":\"24H\",\"date\":\"20220205\",\"time\":\"204009\",\"openPrice\":\"3478000\",\"closePrice\":\"3683000\",\"lowPrice\":\"3381000\",\"highPrice\":\"3705000\",\"value\":\"113522241375.256590787050612\",\"volume\":\"31667.982402273023022265\",\"sellVolume\":\"13969.678445247542400307\",\"buyVolume\":\"17698.303957025480621958\",\"prevClosePrice\":\"3460000\",\"chgRate\":\"5.89\",\"chgAmt\":\"205000\",\"volumePower\":\"126.69\",\"symbol\":\"ETH_KRW\"}}
"""
    let expectedResult = SocketTickerResponse(
      type: "ticker",
      content: SocketTickerData(
        tickType: "24H",
        date: "20220205",
        time: "204009",
        openPrice: "3478000",
        closePrice: "3683000",
        lowPrice: "3381000",
        highPrice: "3705000",
        value: "113522241375.256590787050612",
        volume: "31667.982402273023022265",
        sellVolume: "13969.678445247542400307",
        buyVolume: "17698.303957025480621958",
        prevClosePrice: "3460000",
        chgRate: "5.89",
        chgAmt: "205000",
        volumePower: "126.69",
        symbol: "ETH_KRW"
      )
    )

    // when
    self.scheduler.createColdObservable(
      [
        .next(5, socketText)
      ]
    ).bind(to: self.sut.socketText)
      .disposed(by: self.disposeBag)

    //then
    expect(self.sut.socketTickerData)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(5, expectedResult.content)
        ]
      ))
  }
}
