//
//  UserDefaultsError.swift
//  Cryptocurrency
//
//  Created by 김민성 on 2022/02/20.
//

import Foundation

enum UserDefaultsError: Error {
  case decodingError
  case encodingError
  case unvalidItemError
}
