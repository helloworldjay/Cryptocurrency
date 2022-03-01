//
//  CandleStickResponse.swift
//  Cryptocurrency
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
    throw DecodingError.typeMismatch(
      CandleStickData.self,
      DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Wrong type for Datum"
      )
    )
  }
}
