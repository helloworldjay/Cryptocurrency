//
//  TickerResponse.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/22.
//

import Foundation

struct TickerResponse: Decodable {
  let status: String
  let data: [String: TickerData]
}

struct TickerData: Decodable {
  let openingPrice, closingPrice, minPrice, maxPrice: String
  let tradedUnit, accTradeValue, previousClosingPrice, tradedUnit24H: String
  let accTradeValue24H, fluctate24H, fluctateRate24H: String
  
  enum CodingKeys: String, CodingKey {
    case openingPrice = "opening_price"
    case closingPrice = "closing_price"
    case minPrice = "min_price"
    case maxPrice = "max_price"
    case tradedUnit = "units_traded"
    case accTradeValue = "acc_trade_value"
    case previousClosingPrice = "prev_closing_price"
    case tradedUnit24H = "units_traded_24H"
    case accTradeValue24H = "acc_trade_value_24H"
    case fluctate24H = "fluctate_24H"
    case fluctateRate24H = "fluctate_rate_24H"
  }
}
