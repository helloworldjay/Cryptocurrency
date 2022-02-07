//
//  CoinDetailUseCaseSpy.swift
//  BithumbTests
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation
@testable import Cryptocurrency

import RxSwift

struct NetworkManagerSpy: NetworkManagerLogic {
  
  var tickerResponseStub: Result<AllTickerResponse, APINetworkError>
  var candleStickResponseStub: Result<CandleStickResponse, APINetworkError>
  
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>> {
    return Observable.just(tickerResponseStub)
      .asSingle()
  }
  
  func fetchCandleStickData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>> {
    return Observable.just(candleStickResponseStub)
      .asSingle()
  }
}
