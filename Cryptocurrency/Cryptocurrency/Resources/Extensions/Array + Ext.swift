//
//  Array + Ext.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/01/31.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return self.indices ~= index ? self[index] : nil
  }

  mutating func sort() where Element == OrderBookListViewCellData {
    self.sort { lhs, rhs in
      let lhsPrice = lhs.orderPrice ?? 0.0
      let rhsPrice = rhs.orderPrice ?? 0.0
      return lhsPrice > rhsPrice
    }
  }
}
