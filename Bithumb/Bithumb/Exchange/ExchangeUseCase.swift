//
//  ExchangeUseCase.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxSwift

protocol ExchangeUseCaseLogic {
  func fetchTicker(orderCurrency: OrderCurrency, paymentConcurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, BithumbNetworkError>>
  func tickerResponse(result: Result<AllTickerResponse, BithumbNetworkError>) -> AllTickerResponse?
  func coinListCellData(response: AllTickerResponse?) -> [CoinListViewCellData]
}

struct ExchangeUseCase: ExchangeUseCaseLogic {
  
  // MARK: Properties
  
  let network: NetworkManagerLogic
  
  
  // MARK: Initializers
  
  init(network: NetworkManagerLogic) {
    self.network = network
  }
  
  
  // MARK: Network Logics
  
  func fetchTicker(orderCurrency: OrderCurrency, paymentConcurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, BithumbNetworkError>> {
    return self.network.fetchTickerData(orderCurrency: orderCurrency, paymentCurrency: paymentConcurrency)
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
          ticker: $0.key,
          currentPrice: $0.value.closingPrice,
          priceChangedRatio: $0.value.fluctateRate24H,
          priceDifference: $0.value.fluctate24H,
          transactionAmount: $0.value.accTradeValue24H
        )
      }
  }
}
