//
//  NetworkRequestRouter.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/22.
//

import Foundation

import Alamofire

enum NetworkRequestRouter: URLRequestConvertible {
  
  case fetchTickerData(OrderCurrency, PaymentCurrency)
  case fetchCandleStickData(OrderCurrency, PaymentCurrency, TimeUnit)
  case fetchOrderBookData(OrderCurrency, PaymentCurrency)
  case fetchTransactionHistoryData(OrderCurrency, PaymentCurrency)

  private var baseURLString: String {
    return "https://api.bithumb.com/public"
  }
  
  private var HTTPMethod: Alamofire.HTTPMethod {
    return .get
  }
  
  private var path: String {
    switch self {
    case .fetchTickerData(let orderCurrency, let paymentCurrency):
      return "/ticker" + "/\(orderCurrency.ticker)_\(paymentCurrency.expression)"
    case .fetchCandleStickData(let orderCurrency, let paymentCurrency, let timeUnit):
      return "/candlestick/\(orderCurrency.ticker)_\(paymentCurrency.expression)/\(timeUnit.expression)"
    case .fetchOrderBookData(let orderCurrency, let paymentCurrency):
      return "/orderbook/\(orderCurrency.ticker)_\(paymentCurrency.expression)"
    case .fetchTransactionHistoryData(let orderCurrency, let paymentCurrency):
      return "/transaction_history/\(orderCurrency.ticker)_\(paymentCurrency.expression)"
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try (self.baseURLString + self.path).asURL()
    var request = URLRequest(url: url)
    request.httpMethod = self.HTTPMethod.rawValue
    request.cachePolicy = .reloadIgnoringCacheData
    
    switch self {
    case .fetchTickerData(_, _):
      return request
    case .fetchCandleStickData(_, _, _):
      return request
    case .fetchOrderBookData(_, _):
      return request
    case .fetchTransactionHistoryData(_, _):
      return request
    }
  }
}
