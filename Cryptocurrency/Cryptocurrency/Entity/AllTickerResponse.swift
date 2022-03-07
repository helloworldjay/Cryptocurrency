//
//  TickerResponse.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/22.
//

import Foundation

/**
 {
     "status": "0000",
     "data": {
         "BTC": {
             "opening_price": "41369000",
             "closing_price": "43738000",
             "min_price": "41084000",
             "max_price": "45546000",
             "units_traded": "4209.25437576",
             "acc_trade_value": "183587034224.2125",
             "prev_closing_price": "41368000",
             "units_traded_24H": "7160.3189384",
             "acc_trade_value_24H": "307778152455.7527",
             "fluctate_24H": "513000",
             "fluctate_rate_24H": "1.19"
         },
        ...
     }
 }
 */

struct AllTickerResponse: Decodable {
  let status: String
  let data: [String: TickerData]
}

struct TickerData: Decodable {
  let openingPrice, closingPrice, minPrice, maxPrice: String
  let tradedUnit, accTradeValue, previousClosingPrice, tradedUnit24H: String
  let accTradeValue24H, fluctate24H, fluctateRate24H: String
  let date: String?

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
    case date
  }
}
