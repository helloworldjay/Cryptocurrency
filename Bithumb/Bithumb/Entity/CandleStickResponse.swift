//
//  CandleStickResponse.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/03.
//

import Foundation

/**
{
 "status": "0000",
   "data": [
     [
       1388070000000,
       "737000",
       "755000",
       "755000",
       "737000",
       "3.78"
     ],
     ...
  ]
}
*/

struct CandleStickResponse: Decodable {
  let status: String
  let data: [[CandleStickData]]
  
  var chartData: [ChartData] {
    var timeInterval: Double = 0
    var openPrice: Double = 0
    var closePrice: Double = 0
    var highPrice: Double = 0
    var lowPrice: Double = 0
    var exchangeVolume: Double = 0
    
    return self.data.map { candleStickData -> ChartData? in
      for index in 0..<candleStickData.count {
        guard let candleStickDatum = candleStickData[safe: index] else { return nil }
        
        switch candleStickDatum {
        case .timeInterval(let number):
          timeInterval = number
        case .information(let number):
          guard let number = Double(number) else { return nil }
          
          if index == 1 {
            openPrice = number
          } else if index == 2 {
            closePrice = number
          } else if index == 3 {
            highPrice = number
          } else if index == 4 {
            lowPrice = number
          } else if index == 5 {
            exchangeVolume = number
          }
        }
      }
      return ChartData(timeInterval: timeInterval,
                       openPrice: openPrice,
                       closePrice: closePrice,
                       highPrice: highPrice,
                       lowPrice: lowPrice,
                       exchangeVolume: exchangeVolume)
    }.compactMap { $0 }
  }
}

enum CandleStickData: Decodable {
  case timeInterval(Double)
  case information(String)
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let time = try? container.decode(Double.self) {
      self = .timeInterval(time)
      return
    }
    if let transaction = try? container.decode(String.self) {
      self = .information(transaction)
      return
    }
    throw DecodingError.typeMismatch(CandleStickData.self,
                                     DecodingError.Context(codingPath: decoder.codingPath,
                                                           debugDescription: "Wrong type for Datum"))
  }
}
