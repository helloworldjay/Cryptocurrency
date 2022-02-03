//
//  LetterSaperator.swift
//  Bithumb
//
//  Created by 김민성 on 2022/02/02.
//

import Foundation

final class LetterSeparator {
  
  // MARK: Properties
  
  private static let initialKoreanIndex: UInt32 = 44032
  private static let finalKoreanIndex: UInt32 = 55199
  
  private static let initialCycle: UInt32 = 588
  private static let neutralCycle: UInt32 = 28
  
  private static let initialLetter = [
    "ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
    "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
  ]
  
  private static let neutralLetter = [
    "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ","ㅕ", "ㅖ", "ㅗ", "ㅘ",
    "ㅙ", "ㅚ","ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ",
    "ㅣ"
  ]
  
  private static let finalLetter = [
    "","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ",
    "ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ",
    "ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
  ]
  
  private static let doubledFinalLetter = [
    "ㄳ":"ㄱㅅ","ㄵ":"ㄴㅈ","ㄶ":"ㄴㅎ","ㄺ":"ㄹㄱ","ㄻ":"ㄹㅁ",
    "ㄼ":"ㄹㅂ","ㄽ":"ㄹㅅ","ㄾ":"ㄹㅌ","ㄿ":"ㄹㅍ","ㅀ":"ㄹㅎ",
    "ㅄ":"ㅂㅅ"
  ]
  
  static func seperatedLetter(from input: String) -> String {
    var result = ""
    for scalar in input.unicodeScalars{
      result += separatedLetterFromSyllable(unicodeScalar: scalar) ?? ""
    }
    return result
  }
  
  private static func separatedLetterFromSyllable(unicodeScalar: UnicodeScalar) -> String? {
    if CharacterSet.Korean.contains(unicodeScalar) {
      let index = unicodeScalar.value - initialKoreanIndex
      let initialSeparatedLetter = initialLetter[Int(index / initialCycle)]
      let neutralSeparatedLetter = neutralLetter[Int((index % initialCycle) / neutralCycle)]
      var finalSeparatedLetter = finalLetter[Int(index % neutralCycle)]
      if let disassembledFinal = doubledFinalLetter[finalSeparatedLetter] {
        finalSeparatedLetter = disassembledFinal
      }
      return initialSeparatedLetter + neutralSeparatedLetter + finalSeparatedLetter
    } else {
      return String(UnicodeScalar(unicodeScalar))
    }
  }
}
