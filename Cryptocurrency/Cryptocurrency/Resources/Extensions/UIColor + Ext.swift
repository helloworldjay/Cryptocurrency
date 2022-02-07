//
//  UIColor + Ext.swift
//  Bithumb
//
//  Created by 김민성 on 2022/01/21.
//

import UIKit

extension UIColor {
  func image(_ size: CGSize) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { rendererContext in
      self.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
  }
  
  static var signature: UIColor {
    return UIColor(
      red: 227/255,
      green: 129/255,
      blue: 30/255,
      alpha: 1
    )
  }
  
  static func tickerColor<T: BinaryFloatingPoint>(with number: T) -> UIColor {
    if number > 0 {
      return .red
    } else if number == 0 {
      return .black
    } else {
      return .blue
    }
  }
}
