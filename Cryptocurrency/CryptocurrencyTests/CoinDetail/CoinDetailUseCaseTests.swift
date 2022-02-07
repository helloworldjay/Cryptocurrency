//
//  CoinDetailUseCaseTests.swift
//  BithumbTests
//
//  Created by 이영우 on 2022/02/05.
//

import XCTest
@testable import Cryptocurrency

import Nimble

final class CoinDetailUseCaseTests: XCTestCase {
  
  var sut: CoinDetailUseCaseLogic!
  var networkManagerSpy: NetworkManagerLogic!
  
  
  // MARK: Settings
  
  override func setUp() {
    self.networkManagerSpy = NetworkManager()
    self.sut = CoinDetailUseCase(network: self.networkManagerSpy)
  }
  
  
  // MARK: Tests
  
  func test_AllTickerResponse_네트워크_결과물이_success일_경우_entity를_반환() {
    //given
    let response = AllTickerResponse(status: "0000", data: [:])
    let result: Result<AllTickerResponse, APINetworkError> = .success(response)
    
    //when
    let entity = self.sut.tickerResponse(result: result)
    
    //then
    expect(entity).notTo(beNil())
    expect(entity!.status).to(equal("0000"))
  }
  
  func test_CandleStickResponse_네트워크_결과물이_success일_경우_entity를_반환() {
    //given
    let response = CandleStickResponse(status: "0000", data: [[]])
    let result: Result<CandleStickResponse, APINetworkError> = .success(response)
    
    //when
    let entity = self.sut.candleStickResponse(result: result)
    
    //then
    expect(entity).notTo(beNil())
    expect(entity!.status).to(equal("0000"))
  }
  
  func test_AllTickerResponse가_nil일_경우_ticker_data를_nil로_반환() {
    //given
    let response: AllTickerResponse? = nil
    
    //when
    let tickerData = self.sut.tickerData(response: response)
    
    //then
    expect(tickerData).to(beNil())
  }
  
  func test_CandleStickResponse가_nil일_경우_chart_data를_빈_배열로_반환() {
    //given
    let response: CandleStickResponse? = nil
    
    //when
    let chartData = self.sut.chartData(response: response)
    
    //then
    expect(chartData).to(beEmpty())
  }
  
  func test_AllTickerResponse가_nil이_아닐_경우_ticker_data를_반환() {
    //given
    let response: AllTickerResponse = AllTickerResponse(
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
    )
    
    //when
    let tickerData = self.sut.tickerData(response: response)
    
    //then
    expect(tickerData).toNot(beNil())
    expect(tickerData!.currentPrice).to(equal("2000"))
    expect(tickerData!.priceDifference).to(equal("10000"))
    expect(tickerData!.priceChangedRatio).to(equal("1.0"))
  }
  
  func test_CandleStickResponse가_nil이_아닐_경우_chart_data를_반환() {
    //given
    let response: CandleStickResponse = CandleStickResponse(
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
      ]
    )
    
    //when
    let chartData = self.sut.chartData(response: response)
    
    //then
    expect(chartData).toNot(beEmpty())
    expect(chartData[0].openPrice).to(equal(737000))
    expect(chartData[0].closePrice).to(equal(755000))
    expect(chartData[0].highPrice).to(equal(755000))
    expect(chartData[0].lowPrice).to(equal(737000))
    expect(chartData[0].exchangeVolume).to(equal(3.78))
  }
}
