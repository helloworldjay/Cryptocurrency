//
//  CoinDetailUseCaseSpy.swift
//  CryptocurrencyTests
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation
@testable import Cryptocurrency

import RxSwift

struct NetworkManagerSpy: NetworkManagerLogic {
  
  var tickerResponseStub: Result<AllTickerResponse, APINetworkError>
  var candleStickResponseStub: Result<CandleStickResponse, APINetworkError>
  var orderBookResponseStub: Result<OrderBookResponse, APINetworkError> = .failure(.decodingError)
  var transactionResponseStub: Result<TransactionHistoryResponse, APINetworkError> = .failure(.decodingError)
  
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>> {
    return Observable.just(tickerResponseStub)
      .asSingle()
  }
  
  func fetchCandleStickData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>> {
    return Observable.just(candleStickResponseStub)
      .asSingle()
  }

  func fetchOrderBookData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<OrderBookResponse, APINetworkError>> {
    Observable.just(orderBookResponseStub)
      .asSingle()
  }

  func fetchTransactionHistoryData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<TransactionHistoryResponse, APINetworkError>> {
    Observable.just(transactionResponseStub)
      .asSingle()
  }
}
