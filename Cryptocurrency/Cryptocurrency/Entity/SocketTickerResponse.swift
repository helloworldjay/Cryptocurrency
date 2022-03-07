//
//  SocketTickerResponse.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/02/01.
//

import Foundation

/**
{
  "type" : "ticker",
  "content" : {
    "symbol" : "BTC_KRW",      // 통화코드
    "tickType" : "24H",          // 변동 기준시간- 30M, 1H, 12H, 24H, MID
    "date" : "20200129",        // 일자
    "time" : "121844",          // 시간
    "openPrice" : "2302",        // 시가
    "closePrice" : "2317",        // 종가
    "lowPrice" : "2272",        // 저가
    "highPrice" : "2344",        // 고가
    "value" : "2831915078.07065789",  // 누적거래금액
    "volume" : "1222314.51355788",  // 누적거래량
    "sellVolume" : "760129.34079004",  // 매도누적거래량
    "buyVolume" : "462185.17276784",  // 매수누적거래량
    "prevClosePrice" : "2326",      // 전일종가
    "chgRate" : "0.65",          // 변동률
    "chgAmt" : "15",          // 변동금액
    "volumePower" : "60.80"      // 체결강도
  }
}
*/

struct SocketTickerResponse: Decodable {
  let type: String
  let content: SocketTickerData
}

struct SocketTickerData: Decodable, Equatable {
  let tickType: String
  let date: String
  let time: String
  let openPrice: String
  let closePrice: String
  let lowPrice: String
  let highPrice: String
  let value: String
  let volume: String
  let sellVolume: String
  let buyVolume: String
  let previousClosePrice: String
  let changeRate: String
  let changeAmount: String
  let volumePower: String
  let symbol: String

  enum CodingKeys: String, CodingKey {
    case tickType, date, time, openPrice
    case closePrice, lowPrice, highPrice
    case value, volume, sellVolume, buyVolume
    case volumePower, symbol
    case previousClosePrice = "prevClosePrice"
    case changeRate = "chgRate"
    case changeAmount = "chgAmt"
  }
}
