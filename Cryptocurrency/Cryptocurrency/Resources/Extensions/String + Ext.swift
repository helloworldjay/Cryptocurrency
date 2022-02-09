//
//  String + Ext.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/01/26.
//

import UIKit

extension String {
  func convertToDecimalText() -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    guard let number = Double(self),
          let convertedText = numberFormatter.string(for: number) else {
      return nil
    }
    
    return convertedText
  }

  func convertToPercentageText() -> String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.numberStyle = .percent
    
    guard let number = Double(self),
          let convertedText = numberFormatter.string(for: number) else { return nil }
    return convertedText
  }

  func convertToAttributedString(with color: UIColor) -> NSAttributedString {
    return  NSAttributedString(string: self, attributes: [.foregroundColor : color])
  }
}
