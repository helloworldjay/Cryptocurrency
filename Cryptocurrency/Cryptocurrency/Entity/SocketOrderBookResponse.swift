//
//  SocketOrderBookResponse.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/18.
//

import Foundation

/**
 {
     "type": "orderbookdepth",
     "content": {
         "list": [
             {
                 "symbol": "BTC_KRW", // Ticker
                 "orderType": "ask", // 주문타입 – bid / ask
                 "price": "53365000", // 호가
                 "quantity": "0", // 잔량
                 "total": "0" // 건수
             }
         ],
         "datetime": "1644918923346784"
     }
 }
 */

struct SocketOrderBookResponse: Decodable {
  let type: String
  let content: SocketOrderBookData
}

struct SocketOrderBookData: Decodable {
  let list: [SocketOrderBook]
  let datetime: String
}

struct SocketOrderBook: Decodable {
  let symbol, price, quantity, total: String
  let orderType: OrderBookCategory
}
