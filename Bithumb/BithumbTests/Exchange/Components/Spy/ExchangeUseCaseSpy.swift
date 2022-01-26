//
//  ExchangeUseCaseSpy.swift
//  BithumbTests
//
//  Created by Seungjin Baek on 2022/01/25.
//

import Foundation
@testable import Bithumb

import RxSwift

struct ExchangeUseCaseSpy: ExchangeUseCaseLogic {
  
  var tickerResponseStub: Result<AllTickerResponse, BithumbNetworkError>
  
  func fetchTicker(orderCurrency: OrderCurrency, paymentConcurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, BithumbNetworkError>> {
    return Observable.just(tickerResponseStub)
      .asSingle()
  }
  
  func tickerResponse(result: Result<AllTickerResponse, BithumbNetworkError>) -> AllTickerResponse? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }
  
  func coinListCellData(response: AllTickerResponse?) -> [CoinListViewCellData] {
    guard let response = response else {
      return []
    }
    return response.data
      .map {
        return CoinListViewCellData(
          coinName: OrderCurrency.search(with: $0.key).koreanName,
          ticker: $0.key,
          currentPrice: $0.value.closingPrice,
          priceChangedRatio: $0.value.fluctateRate24H,
          priceDifference: $0.value.fluctate24H,
          transactionAmount: $0.value.accTradeValue24H
        )
      }
  }
}
