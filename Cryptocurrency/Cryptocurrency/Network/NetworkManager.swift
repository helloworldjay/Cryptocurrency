//
//  NetworkManager.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/20.
//

import Foundation

import Alamofire
import RxSwift

protocol NetworkManagerLogic {
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>>
  func fetchCandleStickData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>>
  func fetchOrderBookData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<OrderBookResponse, APINetworkError>>
  func fetchTransactionHistoryData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<TransactionHistoryResponse, APINetworkError>>
}

struct NetworkManager: NetworkManagerLogic {
  
  // MARK: Fetch Data
  
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>> {
    return Single.create { observer -> Disposable in
      AF.request(NetworkRequestRouter.fetchTickerData(orderCurrency, paymentCurrency))
        .validate()
        .response { response in
          switch response.result {
          case .success(let data):
            guard let data = self.dataToDecode(orderCurrency: orderCurrency, data: data) else { return }
            if let response = convertedResponse(orderCurrency: orderCurrency, data: data) {
              observer(.success(.success(response)))
            } else {
              observer(.success(.failure(APINetworkError.decodingError)))
            }
          case .failure(_):
            observer(.success(.failure(APINetworkError.networkError)))
          }
        }
      return Disposables.create()
    }
  }
  
  func fetchCandleStickData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>> {
    return self.fetchData(as: CandleStickResponse.self, router: .fetchCandleStickData(orderCurrency, paymentCurrency, timeUnit))
  }
  
  func fetchOrderBookData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<OrderBookResponse, APINetworkError>> {
    return self.fetchData(as: OrderBookResponse.self, router: .fetchOrderBookData(orderCurrency, paymentCurrency))
  }
  
  func fetchTransactionHistoryData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<TransactionHistoryResponse, APINetworkError>> {
    return self.fetchData(as: TransactionHistoryResponse.self, router: .fetchTransactionHistoryData(orderCurrency, paymentCurrency))
  }

  private func fetchData<T>(as type: T.Type, router: NetworkRequestRouter) -> Single<Result<T, APINetworkError>> where T :Decodable {
    return Single.create { observer -> Disposable in
      AF.request(router)
        .validate()
        .response { response in
          switch response.result {
          case .success(let data):
            guard let data = data else { return }
            let response = try? JSONDecoder().decode(type, from: data)
            if let response = response {
              observer(.success(.success(response)))
            } else {
              observer(.success(.failure(APINetworkError.decodingError)))
            }
          case .failure(_):
            observer(.success(.failure(APINetworkError.networkError)))
          }
        }
      return Disposables.create()
    }
  }
  
  
  // MARK: Converters
  
  func dataToDecode(orderCurrency: OrderCurrency, data: Data?) -> Data? {
    guard let data = data else { return nil }
    if orderCurrency == .all {
      guard let dateRemovedData = self.removeDate(from: data) else { return nil }
      return dateRemovedData
    }
    return data
  }
  
  private func removeDate(from data: Data) -> Data? {
    if var data = self.convertToDictionary(from: data),
       var tickerData = data["data"] as? [String: Any],
       let _ = tickerData.removeValue(forKey: "date") {
      data["data"] = tickerData
      return self.convertToData(from: data)
    }
    return nil
  }
  
  private func convertToDictionary(from data: Data) -> [String: Any]? {
    return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
  }
  
  private func convertToData(from dictionary: [String: Any]) -> Data? {
    return try? JSONSerialization.data(withJSONObject: dictionary, options: [])
  }
  
  func convertedResponse(orderCurrency: OrderCurrency, data: Data) -> AllTickerResponse? {
    if orderCurrency == .all {
      return try? JSONDecoder().decode(AllTickerResponse.self, from: data)
    }
    
    guard let decodedResponse = try? JSONDecoder().decode(TickerResponse.self, from: data) else { return nil }
    return AllTickerResponse(
      status: decodedResponse.status,
      data: [
        orderCurrency.ticker: decodedResponse.data
      ]
    )
  }
}
