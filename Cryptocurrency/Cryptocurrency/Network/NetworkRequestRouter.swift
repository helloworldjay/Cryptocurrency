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

  private var baseURLString: String {
    return "https://api.bithumb.com/public"
  }
  
  private var HTTPMethod: Alamofire.HTTPMethod {
    return .get
  }
  
  private var path: String {
    switch self {
    case .fetchTickerData(let orderCurrency, let paymentCurrency):
      return "/ticker" + "/\(orderCurrency.rawValue)_\(paymentCurrency.rawValue)"
    case .fetchCandleStickData(let orderCurrency, let paymentCurrency, let timeUnit):
      return "/candlestick/\(orderCurrency.rawValue)_\(paymentCurrency.rawValue)/\(timeUnit.rawValue)"
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try (self.baseURLString + self.path).asURL()
     var request = URLRequest(url: url)
     request.httpMethod = self.HTTPMethod.rawValue
    
    switch self {
    case .fetchTickerData(_, _):
      return request
    case .fetchCandleStickData(_, _, _):
      return request
    }
  }
}
