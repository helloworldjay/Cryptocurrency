//
//  String + Ext.swift
//  Bithumb
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
  
  func convertToAttributedString(with color: UIColor) -> NSAttributedString {
    return  NSAttributedString(string: self, attributes: [.foregroundColor : color])
  }
}
