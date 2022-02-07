//
//  CharacterSet + Ext.swift
//  Bithumb
//
//  Created by 김민성 on 2022/02/02.
//

import Foundation

extension CharacterSet {
  static var korean: CharacterSet? {
    guard let firstCharacter = "가".unicodeScalars.first,
          let lastCharacter = "힣".unicodeScalars.first else { return nil }
    return CharacterSet(charactersIn: (firstCharacter)...(lastCharacter))
  }
}
