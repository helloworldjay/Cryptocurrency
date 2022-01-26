//
//  CoinListViewCellData.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/24.
//

import Foundation

struct CoinListViewCellData: Equatable {
  let coinName: String
  let ticker: String
  let currentPrice: String
  let priceChangedRatio: String
  let priceDifference: String
  let transactionAmount: String
}
