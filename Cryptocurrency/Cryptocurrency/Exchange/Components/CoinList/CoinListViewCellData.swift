//
//  CoinListViewCellData.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/24.
//

import UIKit

struct CoinListViewCellData: Equatable, CryptocurrencyPriceData {
  let coinName: String
  let ticker: String
  let currentPrice: String
  let priceChangedRatio: String
  let priceDifference: String
  let transactionAmount: String
}
