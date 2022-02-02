//
//  CharacterSet + Ext.swift
//  Bithumb
//
//  Created by 김민성 on 2022/02/02.
//

import Foundation

extension CharacterSet {
  static var Korean: CharacterSet{
    return CharacterSet(charactersIn: ("가".unicodeScalars.first!)...("힣".unicodeScalars.first!))
  }
}
