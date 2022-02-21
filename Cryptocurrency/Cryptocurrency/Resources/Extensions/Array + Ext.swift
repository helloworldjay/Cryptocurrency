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

  subscript(safe range: Range<Int>) -> [Element]? {
    let lower = range.lowerBound
    let upper = range.upperBound - 1
    let isContained = self.indices ~= (upper) && self.indices ~= (lower)
    return isContained ? Array(self[range]) : nil
  }

  mutating func sortByOrderPrice() where Element == OrderBookListViewCellData {
    self.sort { lhs, rhs in
      let lhsPrice = lhs.orderPrice ?? 0.0
      let rhsPrice = rhs.orderPrice ?? 0.0
      return lhsPrice > rhsPrice
    }
  }

  mutating func sortByTimeInterval() where Element == TransactionSheetViewCellData {
    self.sort { lhs, rhs in
      let lhsTimeInterval = lhs.timeInterval ?? 0.0
      let rhsTimeInterval = rhs.timeInterval ?? 0.0
      return lhsTimeInterval > rhsTimeInterval
    }
  }
  
  func binarySearchForDescending(item: Element) -> Int? where Element: Comparable {
    var low = 0
    var high = self.count - 1

    while low <= high {
      let mid = (low + high) / 2
      let guess = self[mid]
      if guess == item {
        return mid
      } else if guess < item {
        high = mid - 1
      } else {
        low = mid + 1
      }
    }

    return nil
  }
}
