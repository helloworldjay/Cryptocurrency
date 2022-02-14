//
//  ExchangeUseCaseSpy.swift
//  CryptocurrencyTests
//
//  Created by Seungjin Baek on 2022/01/25.
//

import Foundation
@testable import Cryptocurrency

import RxSwift

final class ExchangeUseCaseSpy: ExchangeUseCaseLogic {

  var tickerResponseStub: Result<AllTickerResponse, APINetworkError> = .success(AllTickerResponse(status: "", data: [:]))
  
  func fetchTicker(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>> {
    return Observable.just(self.tickerResponseStub)
      .asSingle()
  }
  
  func tickerResponse(result: Result<AllTickerResponse, APINetworkError>) -> AllTickerResponse? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }

  var coinListCellDataStub: [CoinListViewCellData] = []

  func coinListCellData(response: AllTickerResponse?) -> [CoinListViewCellData] {
    return self.coinListCellDataStub
  }

  var sortedByCoinNameStub: [CoinListViewCellData] = []

  func sortByCoinName(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData] {
    return sortedByCoinNameStub
  }

  var sortedByCurrentPriceStub: [CoinListViewCellData] = []

  func sortByCurrentPrice(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData] {
    return sortedByCurrentPriceStub
  }

  var sortedByPriceChangedRatioStub: [CoinListViewCellData] = []

  func sortByPriceChangedRatio(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData] {
    return sortedByPriceChangedRatioStub
  }

  var sortedByTransactionAmountStub: [CoinListViewCellData] = []

  func sortByTransactionAmount(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData] {
    return sortedByTransactionAmountStub
  }
}
