//
//  CoinPriceData.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/05.
//

import UIKit

struct CoinPriceData: Equatable, CryptoCurrencyDataType {
  let currentPrice: String
  let priceChangedRatio: String
  let priceDifference: String
}
