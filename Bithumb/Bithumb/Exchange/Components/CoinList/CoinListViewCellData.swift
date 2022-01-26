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
          let convertedString = self.priceDifference.convertToDecimalText() else {
        return nil
      }
      
    let color = UIColor.tickerColor(with: priceDifference)
      return convertedString.convertToAttributedString(with: color)
  }
  
  func priceChangedRatioText() -> NSAttributedString? {
    guard var priceChangedRatio = Double(self.priceChangedRatio) else {
      return nil
    }
    
    var percentageText = ""
    priceChangedRatio = round(priceChangedRatio * 100) / 100
    percentageText = priceChangedRatio >= 0 ? "+" : ""
    percentageText.append(String(priceChangedRatio) + "%")
    
    let color = UIColor.tickerColor(with: priceChangedRatio)
    return percentageText.convertToAttributedString(with: color)
  }
  
  func transactionAmountText() -> String? {
    guard let transactionAmount = Double(self.transactionAmount) else {
      return nil
    }
    let millionUnitNumber = Int(round(transactionAmount / 1000000))

    guard var millionUnitText = String(millionUnitNumber).convertToDecimalText() else {
      return nil
    }
    
    millionUnitText += "백만"
    return millionUnitText
  }
}

