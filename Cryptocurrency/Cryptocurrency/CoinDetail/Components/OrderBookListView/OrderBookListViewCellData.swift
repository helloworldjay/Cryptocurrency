//
//  OrderBookListViewCellData.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/07.
//

import Foundation

import Then

struct OrderBookListViewCellData: Equatable {
  let orderBookCategory: OrderBookCategory
  let orderPrice: String?
  let orderQuantity: String?
  let priceChangedRatio: Double?
}

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
