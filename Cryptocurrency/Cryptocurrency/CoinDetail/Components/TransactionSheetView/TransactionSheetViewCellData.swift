//
//  TransactionSheetViewCellData.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/12.
//

import UIKit

struct TransactionSheetViewCellData {
  let orderBookCategory: OrderBookCategory
  let transactionPrice: String
  let dateText: String
  let volume: Double
}

extension TransactionSheetViewCellData {
  func priceText() -> NSAttributedString? {
    let askTextColor = UIColor.red.withAlphaComponent(0.8)
    let bidTextColor = UIColor.blue.withAlphaComponent(0.8)
    let color = (self.orderBookCategory) == .ask ? askTextColor : bidTextColor
    guard let decimalText = self.transactionPrice.convertToDecimalText() else {
      return nil
    }
    return decimalText.convertToAttributedString(with: color)
  }

  func volumeText() -> NSAttributedString? {
    let askTextColor = UIColor.red.withAlphaComponent(0.8)
    let bidTextColor = UIColor.blue.withAlphaComponent(0.8)
    let color = (self.orderBookCategory == .ask) ? askTextColor : bidTextColor
    let numberFormatter = NumberFormatter()
    numberFormatter.minimumFractionDigits = 4
    numberFormatter.maximumFractionDigits = 4
    numberFormatter.numberStyle = .decimal
    let text = numberFormatter.string(for: self.volume)
    return text?.convertToAttributedString(with: color)
  }
}
