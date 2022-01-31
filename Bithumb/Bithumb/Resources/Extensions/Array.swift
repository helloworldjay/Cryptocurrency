//
//  Array.swift
//  Bithumb
//
//  Created by 이영우 on 2022/01/31.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return self.indices ~= index ? self[index] : nil
  }
}
