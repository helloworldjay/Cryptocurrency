//
//  SocketTransactionResponse.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/18.
//

import Foundation

/**
{
   "type": "transaction",
   "content": {
       "list": [
           {
               "buySellGb": "2", // 체결종류(1:매도체결, 매수체결)
               "contPrice": "51224000", // 체결가격
               "contQty": "0.106", // 체결수량
               "contAmt": "5429744.000", // 체결금액
               "contDtm": "2022-02-14 16:13:40.122852", // 체결 시각
               "updn": "dn", // 직전 시세와의 비교 up-상승, down-하락
               "symbol": "BTC_KRW"
           }
       ]
   }
}
*/

struct SocketTransactionResponse: Decodable {
  let type: String
  let content: SocketTransactionHistoryData
}

struct SocketTransactionHistoryData: Decodable {
  let list: [SocketTransactionHistory]
}

struct SocketTransactionHistory: Decodable {
  let contractType, contractPrice, contractQuantity: String
  let contractAmount, contractDatemessage, upDown, symbol: String

  enum CodingKeys: String, CodingKey {
    case contractType = "buySellGb"
    case contractPrice = "contPrice"
    case contractQuantity = "contQty"
    case contractAmount = "contAmt"
    case contractDatemessage = "contDtm"
    case upDown = "updn"
    case symbol
  }
}
