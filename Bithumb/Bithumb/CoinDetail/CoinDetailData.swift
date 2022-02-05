//
//  CoinDetailData.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/05.
//

import UIKit

struct CoinDetailData: Equatable, CryptoCurrencyDataType {
  var currentPrice: String
  var priceChangedRatio: String
  var priceDifference: String
}
