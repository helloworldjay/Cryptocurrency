//
//  NetworkManagerTests.swift
//  BithumbTests
//
//  Created by Seungjin Baek on 2022/01/22.
//

import XCTest
@testable import Bithumb

import Nimble

class NetworkManagerTests: XCTestCase {
  
  var networkManager: NetworkManager!
  
  override func setUp() {
    networkManager = NetworkManager()
  }
  
  func test_Response에_date가_포함될_경우_제거한_후_정상적으로_decode_되는지_확인() throws {
    //given
    let testDataString = """
{
  "status": "0000",
  "data": {
    "BTC": {
      "opening_price": "47210000",
      "closing_price": "44200000",
      "min_price": "43811000",
      "max_price": "47658000",
      "units_traded": "4191.62494387",
      "acc_trade_value": "190106140365.3991",
      "prev_closing_price": "47210000",
      "units_traded_24H": "5295.54430112",
      "acc_trade_value_24H": "242460257780.325",
      "fluctate_24H": "-3825000",
      "fluctate_rate_24H": "-7.96"
    },
    "ETH": {
      "opening_price": "3421000",
      "closing_price": "3066000",
      "min_price": "3037000",
      "max_price": "3489000",
      "units_traded": "54186.53430297",
      "acc_trade_value": "174928381737.8696",
      "prev_closing_price": "3421000",
      "units_traded_24H": "68907.9612685",
      "acc_trade_value_24H": "225860082390.8483",
      "fluctate_24H": "-480000",
      "fluctate_rate_24H": "-13.54"
    },
    "date": "1642841146417"
  }
}
"""
    let testData = Data(testDataString.utf8)
    
    //when
    let dateRemovedData = networkManager.dataToDecode(orderCurrency: .all, data: testData)
    let decodedData = try? JSONDecoder().decode(TickerResponse.self, from: dateRemovedData!)
    
    //then
    expect(decodedData).toNot(beNil())
    expect(decodedData?.data).toNot(beNil())
  }
  
  func test_Response에_date가_없을_경우_decode_되는_지_확인() {
    //given
    let testDataString = """
{
  "status": "0000",
  "data": {
    "BTC": {
      "opening_price": "47210000",
      "closing_price": "44200000",
      "min_price": "43811000",
      "max_price": "47658000",
      "units_traded": "4191.62494387",
      "acc_trade_value": "190106140365.3991",
      "prev_closing_price": "47210000",
      "units_traded_24H": "5295.54430112",
      "acc_trade_value_24H": "242460257780.325",
      "fluctate_24H": "-3825000",
      "fluctate_rate_24H": "-7.96"
    },
    "ETH": {
      "opening_price": "3421000",
      "closing_price": "3066000",
      "min_price": "3037000",
      "max_price": "3489000",
      "units_traded": "54186.53430297",
      "acc_trade_value": "174928381737.8696",
      "prev_closing_price": "3421000",
      "units_traded_24H": "68907.9612685",
      "acc_trade_value_24H": "225860082390.8483",
      "fluctate_24H": "-480000",
      "fluctate_rate_24H": "-13.54"
    }
  }
}
"""
    let testData = Data(testDataString.utf8)
    
    //when
    let data = networkManager.dataToDecode(orderCurrency: .btc, data: testData)
    let decodedData = try? JSONDecoder().decode(TickerResponse.self, from: data!)
    
    //then
    expect(decodedData).toNot(beNil())
    expect(decodedData?.data).toNot(beNil())
  }
}
