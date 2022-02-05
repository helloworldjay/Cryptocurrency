//
//  CoinListViewCellData.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/24.
//

import UIKit

struct CoinListViewCellData: Equatable, CryptoCurrencyDataType {
  let coinName: String
  let ticker: String
  var currentPrice: String
  var priceChangedRatio: String
  var priceDifference: String
  let transactionAmount: String
}

extension CoinListViewCellData {
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
}

