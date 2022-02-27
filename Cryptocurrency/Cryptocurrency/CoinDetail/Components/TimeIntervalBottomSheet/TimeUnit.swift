//
//  TimeUnit.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/01/31.
//

import Foundation

enum TimeUnit: CaseIterable {
  case oneMinute
  case threeMinute
  case fiveMinute
  case tenMinute
  case thirtyMinute
  case oneHour
  case sixHour
  case twelveHour
  case twentyFourHour

  var expression: String {
    switch self {
    case .oneMinute:
      return "1m"
    case .threeMinute:
      return "3m"
    case .fiveMinute:
      return "5m"
    case .tenMinute:
      return "10m"
    case .thirtyMinute:
      return "30m"
    case .oneHour:
      return "1h"
    case .sixHour:
      return "6h"
    case .twelveHour:
      return "12h"
    case .twentyFourHour:
      return "24h"
    }
  }
}
