//
//  OrderBookListViewCellData.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/07.
//

import Foundation

import Then

struct OrderBookListViewCellData {
  let orderBookCategory: OrderBookCategory
  let orderPrice: Double?
  let orderQuantity: Double?
  let priceChangedRatio: Double?
}


// MARK: - Equatable

extension OrderBookListViewCellData: Equatable {
  static func == (lhs: OrderBookListViewCellData, rhs: OrderBookListViewCellData) -> Bool {
    let lhsPrice = lhs.orderPrice ?? 0
    let rhsPrice = rhs.orderPrice ?? 0
    return lhsPrice == rhsPrice
  }
}


// MARK: - Comparable

extension OrderBookListViewCellData: Comparable {
  static func < (lhs: OrderBookListViewCellData, rhs: OrderBookListViewCellData) -> Bool {
    let lhsPrice = lhs.orderPrice ?? 0
    let rhsPrice = rhs.orderPrice ?? 0
    return lhsPrice < rhsPrice
  }
}


// MARK: - Editing Logic

extension OrderBookListViewCellData {
  func priceChangedRatioText() -> NSAttributedString? {
    guard let priceChangedRatio = self.priceChangedRatio else { return nil }
    let sign = priceChangedRatio.signText()
    let color = UIColor.tickerColor(with: priceChangedRatio)
    guard let priceChangedPercentage = String(abs(priceChangedRatio)).convertToPercentageText() else {
      return nil
    }

    let percentageText = sign + priceChangedPercentage
    return percentageText.convertToAttributedString(with: color)
  }

  func orderPriceText() -> NSAttributedString? {
    guard let orderPrice = self.orderPrice,
          let priceChangedRatio = self.priceChangedRatio,
          let priceText = orderPrice.convertToDecimalText() else {
            return nil
          }
    let color = UIColor.tickerColor(with: priceChangedRatio)
    return priceText.convertToAttributedString(with: color)
  }

  func orderQuantityText() -> String? {
    guard let orderQuantity = self.orderQuantity else { return nil }
    return orderQuantity.convertToDecimalText()
  }
}
