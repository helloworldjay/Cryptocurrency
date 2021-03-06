//
//  GraphData.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/01/31.
//

import Foundation

struct ChartData: Equatable {
  var timeInterval = 0.0
  var openPrice = 0.0
  var closePrice = 0.0
  var highPrice = 0.0
  var lowPrice = 0.0
  var exchangeVolume = 0.0
  
  var dateText: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd\nHH:mm"
    let date = Date(timeIntervalSince1970: self.timeInterval / 1000)
    return dateFormatter.string(from: date)
  }
}
