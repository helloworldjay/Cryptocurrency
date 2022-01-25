//
//  ExchangeUseCaseTests.swift
//  BithumbTests
//
//  Created by Seungjin Baek on 2022/01/25.
//

import XCTest
@testable import Bithumb

import Nimble

class ExchangeUseCaseTests: XCTestCase {
  
  var sut: ExchangeUseCaseLogic!
  var networkManagerSpy: NetworkManagerLogic!
  
  
  // MARK: Settings
  
  override func setUp() {
    self.networkManagerSpy = NetworkManager()
    self.sut = ExchangeUseCase(network: self.networkManagerSpy)
  }
  
  
  // MARK: Tests
  
  func test_네트워크_결과물이_success일_경우_entity를_반환() {
    //given
    let response = AllTickerResponse(status: "0000", data: [:])
    let result: Result<AllTickerResponse, BithumbNetworkError> = .success(response)
    
    //when
    let entity = self.sut.tickerResponse(result: result)
    
    //then
    expect(entity).notTo(beNil())
    expect(entity!.status).to(equal("0000"))
  }
  
  func test_entity가_nil일_경우_cell_data를_빈_배열로_반환() {
    //given
    let response: AllTickerResponse? = nil
    
    //when
    let cellData = self.sut.coinListCellData(response: response)
    
    //then
    expect(cellData).to(beEmpty())
  }
  
  func test_entity가_nil이_아닐_경우_cell_data를_반환() {
    //given
    let response: AllTickerResponse? = AllTickerResponse(
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
    let cellData = self.sut.coinListCellData(response: response)
    
    //then
    expect(cellData).toNot(beEmpty())
    expect(cellData[0].ticker).to(equal("BTC"))
    expect(cellData[0].currentPrice).to(equal("2000"))
    expect(cellData[0].priceChangedRatio).to(equal("1.0"))
  }
}
