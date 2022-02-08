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
}
