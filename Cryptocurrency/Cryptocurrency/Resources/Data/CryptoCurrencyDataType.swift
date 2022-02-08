//
//  CryptoCurrencyDataType.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/06.
//

import UIKit

protocol CryptoCurrencyDataType {
  var currentPrice: String { get }
  var priceChangedRatio: String { get }
  var priceDifference: String { get }
  func currentPriceText() -> NSAttributedString?
  func priceDifferenceText() -> NSAttributedString?
  func priceChangedRatioText() -> NSAttributedString?
}

extension CryptoCurrencyDataType {
  func currentPriceText() -> NSAttributedString? {
    guard let priceDifference = Double(self.priceDifference),
          let priceText = self.currentPrice.convertToDecimalText() else {
      return nil
    }
    
    let color = UIColor.tickerColor(with: priceDifference)
    return priceText.convertToAttributedString(with: color)
  }
  
  func priceDifferenceText() -> NSAttributedString? {
    guard let priceDifference = Double(self.priceDifference),
          let convertedString = String(abs(priceDifference)).convertToDecimalText() else {
            return nil
          }
    
    let sign = priceDifference.signText()
    let color = UIColor.tickerColor(with: priceDifference)
    let priceDifferenceText = sign + convertedString
    return priceDifferenceText.convertToAttributedString(with: color)
  }
  
  func priceChangedRatioText() -> NSAttributedString? {
    guard let priceChangedRatio = Double(self.priceChangedRatio) else {
      return nil
    }
    
    let sign = priceChangedRatio.signText()
    let color = UIColor.tickerColor(with: priceChangedRatio)
    let slicedPriceChangedRatio = abs(floor(priceChangedRatio * 100) / 100)
    let percentageText = sign + String(slicedPriceChangedRatio) + "%"
    return percentageText.convertToAttributedString(with: color)
  }
}
