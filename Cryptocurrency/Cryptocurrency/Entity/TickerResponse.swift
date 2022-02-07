//
//  TickerResponse.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/25.
//

import Foundation

/**
 {
     "status": "0000",
     "data": {
         "opening_price": "41369000",
         "closing_price": "44027000",
         "min_price": "41084000",
         "max_price": "45546000",
         "units_traded": "4530.72099928",
         "acc_trade_value": "197702716416.6475",
         "prev_closing_price": "41368000",
         "units_traded_24H": "6673.65642084",
         "acc_trade_value_24H": "287026523345.5483",
         "fluctate_24H": "1024000",
         "fluctate_rate_24H": "2.38",
         "date": "1643101115538"
     }
 }
 */

struct TickerResponse: Decodable {
  let status: String
  let data: TickerData
}
