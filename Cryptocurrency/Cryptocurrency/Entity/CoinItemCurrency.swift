//
//  CoinItemCurrency.swift
//  Cryptocurrency
//
//  Created by 김민성 on 2022/02/20.
//

import Foundation

struct CoinItemCurrency: Codable, Hashable {
  var orderCurrency: OrderCurrency
  var paymentCurrency: PaymentCurrency
}
