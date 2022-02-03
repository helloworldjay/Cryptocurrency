//
//  LetterSaperator.swift
//  Bithumb
//
//  Created by 김민성 on 2022/02/02.
//

import Foundation

final class LetterSeparator {
  
  // MARK: Properties
  
  static let initialKoreanIndex: UInt32 = 44032
  static let finalKoreanIndex: UInt32 = 55199
  
  static let initialCycle: UInt32 = 588
  static let neutralCycle: UInt32 = 28
  
  static let initial = [
    "ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
    "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
  ]
  
  static let neutral = [
    "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ","ㅕ", "ㅖ", "ㅗ", "ㅘ",
    "ㅙ", "ㅚ","ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ",
    "ㅣ"
  ]
  
  static let final = [
    "","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ",
    "ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ",
    "ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
  ]
  
  static let doubledFinal = [
    "ㄳ":"ㄱㅅ","ㄵ":"ㄴㅈ","ㄶ":"ㄴㅎ","ㄺ":"ㄹㄱ","ㄻ":"ㄹㅁ",
    "ㄼ":"ㄹㅂ","ㄽ":"ㄹㅅ","ㄾ":"ㄹㅌ","ㄿ":"ㄹㅍ","ㅀ":"ㄹㅎ",
    "ㅄ":"ㅂㅅ"
  ]
  
  static func getSeparatedLetter(of input: String) -> String {
    var result = ""
    for scalar in input.unicodeScalars{
      result += getSeparatedLetterFromSyllable(scalar) ?? ""
    }
    return result
  }
  
  private static func getSeparatedLetterFromSyllable(_ unicodeScalar: UnicodeScalar) -> String? {
    if CharacterSet.Korean.contains(unicodeScalar) {
      let index = unicodeScalar.value - initialKoreanIndex
      let initial = initial[Int(index / initialCycle)]
      let neutral = neutral[Int((index % initialCycle) / neutralCycle)]
      var final = final[Int(index % neutralCycle)]
      if let disassembledFinal = doubledFinal[final] {
        final = disassembledFinal
      }
      return initial + neutral + final
    } else {
      return String(UnicodeScalar(unicodeScalar))
    }
  }
}
