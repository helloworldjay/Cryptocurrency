//
//  PriceDataTextEditable.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/03/05.
//

import UIKit

protocol PriceDataTextEditable: UIView {
  func currentPriceText(with cryptocurrencyPriceData: CryptocurrencyPriceData) -> NSAttributedString?
  func priceDifferenceText(with cryptocurrencyPriceData: CryptocurrencyPriceData) -> NSAttributedString?
  func priceChangedRatioText(with cryptocurrencyPriceData: CryptocurrencyPriceData) -> NSAttributedString?
}

extension PriceDataTextEditable {
  func currentPriceText(with cryptocurrencyPriceData: CryptocurrencyPriceData) -> NSAttributedString? {
    guard let priceDifference = Double(cryptocurrencyPriceData.priceDifference),
          let priceText = cryptocurrencyPriceData.currentPrice.convertToDecimalText() else {
      return nil
    }

    let color = UIColor.tickerColor(with: priceDifference)
    return priceText.convertToAttributedString(with: color)
  }

  func priceDifferenceText(with cryptocurrencyPriceData: CryptocurrencyPriceData) -> NSAttributedString? {
    guard let priceDifference = Double(cryptocurrencyPriceData.priceDifference),
          let convertedString = String(abs(priceDifference)).convertToDecimalText() else {
            return nil
          }

    let sign = priceDifference.signText()
    let color = UIColor.tickerColor(with: priceDifference)
    let priceDifferenceText = sign + convertedString
    return priceDifferenceText.convertToAttributedString(with: color)
  }

  func priceChangedRatioText(with cryptocurrencyPriceData: CryptocurrencyPriceData) -> NSAttributedString? {
    guard let priceChangedRatio = Double(cryptocurrencyPriceData.priceChangedRatio) else {
      return nil
    }

    let sign = priceChangedRatio.signText()
    let color = UIColor.tickerColor(with: priceChangedRatio)
    let slicedPriceChangedRatio = abs(floor(priceChangedRatio * 100) / 100)
    let percentageText = sign + String(slicedPriceChangedRatio) + "%"
    return percentageText.convertToAttributedString(with: color)
  }
}
