//
//  CoinListViewCellData.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/24.
//

import UIKit

struct CoinListViewCellData: Equatable {
  let coinName: String
  let ticker: String
  let currentPrice: String
  let priceChangedRatio: String
  let priceDifference: String
  let transactionAmount: String
}

extension CoinListViewCellData {
  func currentPriceText() -> NSAttributedString? {
    guard let priceDifference = Double(self.priceDifference) else {
      return nil
    }
    
    let priceText = self.currentPrice.convertToDecimalText()
    let color = UIColor.tickerColor(with: priceDifference)
    return priceText?.convertToAttributedString(with: color)
  }
  
  func priceDifferenceText() -> NSAttributedString? {
    guard let priceDifference = Double(self.priceDifference),
          let convertedString = String(abs(priceDifference)).convertToDecimalText() else {
            return nil
          }
    
    let sign = self.sign(about: priceDifference)
    let color = UIColor.tickerColor(with: priceDifference)
    let priceDifferenceText = sign + convertedString
    return priceDifferenceText.convertToAttributedString(with: color)
  }
  
  func priceChangedRatioText() -> NSAttributedString? {
    guard let priceChangedRatio = Double(self.priceChangedRatio) else {
      return nil
    }
    
    let sign = self.sign(about: priceChangedRatio)
    let color = UIColor.tickerColor(with: priceChangedRatio)
    let slicedPriceChangedRatio = abs(floor(priceChangedRatio * 100) / 100)
    let percentageText = sign + String(slicedPriceChangedRatio) + "%"
    return percentageText.convertToAttributedString(with: color)
  }
  
  func transactionAmountText() -> String? {
    guard let transactionAmount = Double(self.transactionAmount) else {
      return nil
    }
    let millionUnitNumber = Int(floor(transactionAmount / 1000000))
    
    guard var millionUnitText = String(millionUnitNumber).convertToDecimalText() else {
      return nil
    }
    
    millionUnitText += "백만"
    return millionUnitText
  }
  
  private func sign(about number: Double) -> String {
    if number == .zero {
      return ""
    } else if number > .zero {
      return "+"
    } else {
      return "-"
    }
  }
}

