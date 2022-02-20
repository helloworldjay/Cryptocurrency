//
//  ExchangeUseCase.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxSwift

protocol ExchangeUseCaseLogic {
  func fetchTicker(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>>
  func tickerResponse(result: Result<AllTickerResponse, APINetworkError>) -> AllTickerResponse?
  func coinListCellData(response: AllTickerResponse?) -> [CoinListViewCellData]
  func favoriteGridCellData(currencies: [CoinItemCurrency]) -> [FavoriteGridViewCellData]
  func sortByCoinName(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData]
  func sortByCurrentPrice(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData]
  func sortByPriceChangedRatio(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData]
  func sortByTransactionAmount(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData]
}

struct ExchangeUseCase: ExchangeUseCaseLogic {
  
  // MARK: Properties
  
  let network: NetworkManagerLogic
  
  
  // MARK: Initializers
  
  init(network: NetworkManagerLogic) {
    self.network = network
  }
  
  
  // MARK: Network Logics

  func fetchTicker(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>> {
    return self.network.fetchTickerData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
  }
  
  func tickerResponse(result: Result<AllTickerResponse, APINetworkError>) -> AllTickerResponse? {
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

  func favoriteGridCellData(currencies: [CoinItemCurrency]) -> [FavoriteGridViewCellData] {
    return currencies
      .map {
        return FavoriteGridViewCellData(
          coinName: $0.orderCurrency.koreanName,
          ticker: $0.orderCurrency.rawValue,
          paymentCurrency: $0.paymentCurrency.rawValue)
      }
  }

  func sortByCoinName(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData] {
    return coinListCellData.sorted { lhs, rhs -> Bool in
      if isDescending {
        return lhs.coinName > rhs.coinName
      }
      return lhs.coinName < rhs.coinName
    }
  }

  func sortByCurrentPrice(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData] {
    return coinListCellData.sorted { lhs, rhs -> Bool in
      guard let lhsCurrentPrice = Double(lhs.currentPrice),
            let rhsCurrentPrice = Double(rhs.currentPrice) else { return true }
      if isDescending {
        return lhsCurrentPrice > rhsCurrentPrice
      }
      return lhsCurrentPrice < rhsCurrentPrice
    }
  }

  func sortByPriceChangedRatio(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData] {
    return coinListCellData.sorted { lhs, rhs -> Bool in
      guard let lhsPriceChangedRatio = Double(lhs.priceChangedRatio),
            let rhsPriceChangedRatio = Double(rhs.priceChangedRatio) else { return true }
      if isDescending {
        return lhsPriceChangedRatio > rhsPriceChangedRatio
      }
      return lhsPriceChangedRatio < rhsPriceChangedRatio
    }
  }

  func sortByTransactionAmount(coinListCellData: [CoinListViewCellData], isDescending: Bool) -> [CoinListViewCellData] {
    return coinListCellData.sorted { lhs, rhs -> Bool in
      guard let lhsTransactionAmount = Double(lhs.transactionAmount),
            let rhsTransactionAmount = Double(rhs.transactionAmount) else { return true }
      if isDescending {
        return lhsTransactionAmount > rhsTransactionAmount
      }
      return lhsTransactionAmount < rhsTransactionAmount
    }
  }
}
