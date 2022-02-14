//
//  CoinDetailCategory.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/08.
//

import Foundation

enum CoinDetailCategory: Int, CaseIterable {
  case orderBook
  case chart
  case transactionHistory
  
  static func findCategory(with index: Int) -> Self {
    guard let category = CoinDetailCategory.allCases
            .filter({ $0.rawValue == index })
            .first else { return .orderBook }
    return category
  }
}
