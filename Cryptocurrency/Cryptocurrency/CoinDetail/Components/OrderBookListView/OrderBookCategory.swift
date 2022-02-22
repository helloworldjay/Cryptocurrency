//
//  OrderBook.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/08.
//

import Foundation

enum OrderBookCategory: String, CaseIterable, Decodable {
  case bid
  case ask

  static func findOrderBookCategory(with text: String) -> Self? {
    guard let orderBookCategory = OrderBookCategory.allCases
            .filter({ $0.rawValue == text })
            .first else { return .bid }
    return orderBookCategory
  }
}
