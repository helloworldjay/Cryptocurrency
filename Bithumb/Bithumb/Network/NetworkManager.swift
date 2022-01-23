//
//  NetworkManager.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import Foundation

import Alamofire
import RxSwift

struct NetworkManager: NetworkManagerLogic {
  
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
