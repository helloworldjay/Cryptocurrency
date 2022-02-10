//
//  OrderBookResponse.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/09.
//

import Foundation

/**
 {
   "status" : "0000",
   "data" : {
     "timestamp" : 1417142049868,
     "order_currency" : "BTC",
     "payment_currency" : "KRW",
     "bids": [
       {
         "quantity" : "6.1189306",
         "price" : "504000"
       },
       {
         "quantity" : "10.35117828",
         "price" : "503000"
       }
     ],
     "asks": [
       {
         "quantity" : "2.67575",
         "price" : "506000"
       },
       {
         "quantity" : "3.54343",
         "price" : "507000"
       }
     ]
   }
 }
 */

struct OrderBookResponse: Decodable {
  let status: String
  let data: OrderBookData

  func orderBookListViewCellData(by closingPrice: Double) -> [OrderBookListViewCellData] {
    let bids = self.data.bids.map { orderBook -> OrderBookListViewCellData? in
      guard let orderPrice = Double(orderBook.price) else { return nil }
      return OrderBookListViewCellData(
        orderBook: .bid,
        orderPrice: orderBook.price,
        orderQuantity: orderBook.quantity,
        priceChangedRatio: (orderPrice - closingPrice) / closingPrice
      )
    }.compactMap { $0 }

    let asks = self.data.asks.map { orderBook -> OrderBookListViewCellData? in
      guard let orderPrice = Double(orderBook.price) else { return nil }
      return OrderBookListViewCellData(
        orderBook: .ask,
        orderPrice: orderBook.price,
        orderQuantity: orderBook.quantity,
        priceChangedRatio: (orderPrice - closingPrice) / closingPrice
      )
    }.compactMap { $0 }

    return (bids + asks).sorted(by: { $0.orderPrice > $1.orderPrice })
  }
}

struct OrderBookData: Decodable {
  let timestamp: String
  let orderCurrency: String
  let paymentCurrency: String
  let bids: [OrderBook]
  let asks: [OrderBook]

  enum CodingKeys: String, CodingKey {
    case timestamp, bids, asks
    case orderCurrency = "order_currency"
    case paymentCurrency = "payment_currency"
  }
}

struct OrderBook: Decodable {
  let quantity: String
  let price: String
}
