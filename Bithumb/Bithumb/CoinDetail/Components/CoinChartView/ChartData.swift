//
//  GraphData.swift
//  Bithumb
//
//  Created by 이영우 on 2022/01/31.
//

import Foundation

struct ChartData: Equatable {
  var timeInterval: Double = 0.0
  var openPrice: Double = 0.0
  var closePrice: Double = 0.0
  var highPrice: Double = 0.0
  var lowPrice: Double = 0.0
  var exchangeVolume: Double = 0.0
  
  var dateText: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd\nHH:mm"
    let date = Date(timeIntervalSince1970: self.timeInterval / 1000)
    return dateFormatter.string(from: date)
  }
}
