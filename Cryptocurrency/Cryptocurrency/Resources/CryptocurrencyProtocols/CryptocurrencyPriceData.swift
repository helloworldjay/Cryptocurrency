//
//  CryptocurrencyPriceData.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/06.
//

import UIKit

protocol CryptocurrencyPriceData {
  var currentPrice: String { get }
  var priceChangedRatio: String { get }
  var priceDifference: String { get }
}
