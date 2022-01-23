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
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<TickerResponse>
}

struct NetworkManager: NetworkManagerLogic {
  
  // MARK: Fetch Data
  
  func fetchTickerData(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<TickerResponse> {
    return Single.create { observer -> Disposable in
      AF.request(NetworkRequestRouter.fetchTickerData(orderCurrency, paymentCurrency))
        .validate()
        .response { response in
          switch response.result {
          case .success(let data):
            guard let data = self.dataToDecode(orderCurrency: orderCurrency, data: data) else { return }
            if let response = try? JSONDecoder().decode(TickerResponse.self, from: data) {
              observer(.success(response))
            } else {
              observer(.failure(NetworkError.decodingError))
            }
          case .failure(_):
            observer(.failure(NetworkError.networkError))
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
}
