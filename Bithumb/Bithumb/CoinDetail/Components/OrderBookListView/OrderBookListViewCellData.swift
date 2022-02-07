//
//  OrderBookListViewCellData.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/07.
//

import Foundation

import Then

struct OrderBookListViewCellData: Equatable {
  let orderPrice: String
  let orderQuantity: String
}

extension OrderBookListViewCellData {
  func priceChangedRatioText(with openPrice: Double) -> NSAttributedString? {
    guard let orderPrice = Double(orderPrice) else { return nil }
    let priceChangedRatio = (orderPrice - openPrice) / openPrice

    let sign = priceChangedRatio.signText()
    let color = UIColor.tickerColor(with: priceChangedRatio)

    guard let priceChangedPercentage = String(abs(priceChangedRatio)).convertToPercentageText() else {
      return nil
    }

    let percentageText = sign + priceChangedPercentage
    return percentageText.convertToAttributedString(with: color)
  }

  func orderPriceText() -> NSAttributedString? {
    guard let orderPrice = Double(self.orderPrice),
          let priceText = self.orderPrice.convertToDecimalText() else {
            return nil
          }

    let color = UIColor.tickerColor(with: orderPrice)
    return priceText.convertToAttributedString(with: color)
  }

  func orderQuantityText() -> String? {
    return self.orderQuantity.convertToDecimalText()
  }
}
