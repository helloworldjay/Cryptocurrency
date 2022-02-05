//
//  CoinDetailViewModelTests.swift
//  BithumbTests
//
//  Created by 이영우 on 2022/02/05.
//

import XCTest
@testable import Bithumb

import Nimble
import RxNimble
import RxSwift
import RxTest

final class CoinDetailViewModelTests: XCTestCase {
  
  var sut: CoinDetailViewModel!
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!
  
  
  // MARK: Settings
  
  override func setUp() {
    let tickerResponseStub: Result<AllTickerResponse, BithumbNetworkError> = .success(AllTickerResponse(
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
          fluctate24H: "30000",
          fluctateRate24H: "1.0",
          date: nil
        )
      ]
    ))
    let candleStickResponseStub: Result<CandleStickResponse, BithumbNetworkError> = .success(CandleStickResponse(
      status: "0000",
      data: [
        [
          .timeInterval(1388070000000),
          .information("737000"),
          .information("755000"),
          .information("755000"),
          .information("737000"),
          .information("3.78")
        ]
      ])
    )
    let payload = CoinDetailViewController.Payload(orderCurrency: .btc, paymentCurrency: .krw)
    let networkManagerSpy = NetworkManagerSpy(tickerResponseStub: tickerResponseStub,
                                              candleStickResponseStub: candleStickResponseStub)
    let useCase = CoinDetailUseCase(network: networkManagerSpy)
    self.sut = CoinDetailViewModel(useCase: useCase,
                                   payload: payload)
    self.scheduler = TestScheduler(initialClock: 0)
    self.disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    self.disposeBag = DisposeBag()
  }
  
  
  // MARK: Tests
  
  func test_timeUnit을_변경하였을_때_coinChartViewModel로_chartData가_전달되는_지_확인() throws {
    //given
    let chartData = ChartData(
      timeInterval: 1388070000000,
      openPrice: 737000,
      closePrice: 755000,
      highPrice: 755000,
      lowPrice: 737000,
      exchangeVolume: 3.78
    )
    
    //when
    self.scheduler.createColdObservable(
      [
        .next(5, TimeUnit.oneMinute)
      ]
    ).bind(to: self.sut.selectedTimeUnit)
      .disposed(by: self.disposeBag)
    
    //then
    expect(self.sut.coinChartViewModel.chartData)
      .events(scheduler: self.scheduler, disposeBag: self.disposeBag)
      .to(equal(
        [
          .next(5, [chartData])
        ]
      ))
  }
}
