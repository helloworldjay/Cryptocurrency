//
//  Double + Ext.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation

extension Double {
  func signText() -> String {
    if self == .zero {
      return ""
    } else if self > .zero {
      return "+"
    } else {
      return "-"
    }
  }

  func convertToDecimalText() -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 4
    numberFormatter.numberStyle = .decimal
    
    guard let convertedText = numberFormatter.string(for: self) else {
      return nil
    }
    
    return convertedText
  }
}
