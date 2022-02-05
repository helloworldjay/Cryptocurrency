//
//  NetworkManager.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import Foundation

import Alamofire
import RxSwift

protocol NetworkManagerLogic {
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, BithumbNetworkError>>
  func fetchCandleStickData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeInterval: TimeInterval) -> Single<Result<CandleStickResponse, BithumbNetworkError>>
}

struct NetworkManager: NetworkManagerLogic {
  
  // MARK: Fetch Data
  
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, BithumbNetworkError>> {
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
              observer(.success(.failure(BithumbNetworkError.decodingError)))
            }
          case .failure(_):
            observer(.success(.failure(BithumbNetworkError.networkError)))
          }
        }
      return Disposables.create()
    }
  }
  
  func fetchCandleStickData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeInterval: TimeInterval) -> Single<Result<CandleStickResponse, BithumbNetworkError>> {
    return Single.create { observer -> Disposable in
      AF.request(NetworkRequestRouter.fetchCandleStickData(orderCurrency, paymentCurrency, timeInterval))
        .validate()
        .response { response in
          switch response.result {
          case .success(let data):
            guard let data = data else { return }
            let response = try? JSONDecoder().decode(CandleStickResponse.self, from: data)
            if let response = response {
              observer(.success(.success(response)))
            } else {
              observer(.success(.failure(BithumbNetworkError.decodingError)))
            }
          case .failure(_):
            observer(.success(.failure(BithumbNetworkError.networkError)))
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
        orderCurrency.rawValue:TickerData(
          openingPrice: decodedResponse.data.openingPrice,
          closingPrice: decodedResponse.data.closingPrice,
          minPrice: decodedResponse.data.minPrice,
          maxPrice: decodedResponse.data.maxPrice,
          tradedUnit: decodedResponse.data.tradedUnit,
          accTradeValue: decodedResponse.data.accTradeValue,
          previousClosingPrice: decodedResponse.data.previousClosingPrice,
          tradedUnit24H: decodedResponse.data.tradedUnit24H,
          accTradeValue24H: decodedResponse.data.accTradeValue24H,
          fluctate24H: decodedResponse.data.fluctate24H,
          fluctateRate24H: decodedResponse.data.fluctateRate24H,
          date: nil
        )
      ]
    )
  }
}
