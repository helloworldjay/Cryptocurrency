//
//  OrderBookListViewCellData.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/07.
//

import Foundation

import Then

struct OrderBookListViewCellData: Equatable {
  let orderBook: OrderBook
  let orderPrice: String
  let orderQuantity: String
  let priceChangedRatio: Double
}

extension OrderBookListViewCellData {
  func priceChangedRatioText() -> NSAttributedString? {
    let sign = self.priceChangedRatio.signText()
    let color = UIColor.tickerColor(with: self.priceChangedRatio)

    guard let priceChangedPercentage = String(abs(self.priceChangedRatio)).convertToPercentageText() else {
      return nil
    }

    let percentageText = sign + priceChangedPercentage
    return percentageText.convertToAttributedString(with: color)
  }

  func orderPriceText() -> NSAttributedString? {
    guard let priceText = self.orderPrice.convertToDecimalText() else { return nil }
    let color = UIColor.tickerColor(with: self.priceChangedRatio)
    return priceText.convertToAttributedString(with: color)
  }

  func orderQuantityText() -> String? {
    return self.orderQuantity.convertToDecimalText()
  }
}
