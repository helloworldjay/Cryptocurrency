//
//  CoinDetailUseCaseSpy.swift
//  BithumbTests
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation
@testable import Bithumb

import RxSwift

struct NetworkManagerSpy: NetworkManagerLogic {
  
  var tickerResponseStub: Result<AllTickerResponse, BithumbNetworkError>
  var candleStickResponseStub: Result<CandleStickResponse, BithumbNetworkError>
  
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, BithumbNetworkError>> {
    return Observable.just(tickerResponseStub)
      .asSingle()
  }
  
  func fetchCandleStickData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, BithumbNetworkError>> {
    return Observable.just(candleStickResponseStub)
      .asSingle()
  }
}
