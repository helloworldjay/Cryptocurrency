//
//  LetterSaperator.swift
//  Cryptocurrency
//
//  Created by 김민성 on 2022/02/02.
//

import Foundation

final class LetterSeparator {
  
  // MARK: Properties
  
  private let initialKoreanIndex: UInt32 = 44032
  private let finalKoreanIndex: UInt32 = 55199
  
  private let firstConsonantCycle: UInt32 = 588
  private let middleVowelCycle: UInt32 = 28
  
  private let firstConsonantLetter = [
    "ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ",
    "ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
  ]
  
  private let middleVowelLetter = [
    "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ","ㅕ", "ㅖ", "ㅗ", "ㅘ",
    "ㅙ", "ㅚ","ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ",
    "ㅣ"
  ]
  
  private let lastConsonantLetter = [
    "","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ",
    "ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ",
    "ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"
  ]
  
  private let separatedDoubledLastConsonantLetter = [
    "ㄳ":"ㄱㅅ","ㄵ":"ㄴㅈ","ㄶ":"ㄴㅎ","ㄺ":"ㄹㄱ","ㄻ":"ㄹㅁ",
    "ㄼ":"ㄹㅂ","ㄽ":"ㄹㅅ","ㄾ":"ㄹㅌ","ㄿ":"ㄹㅍ","ㅀ":"ㄹㅎ",
    "ㅄ":"ㅂㅅ"
  ]
  
  func seperatedLetter(from input: String) -> String {
    var result = ""
    for scalar in input.unicodeScalars{
      result += separatedLetterFromSyllable(unicodeScalar: scalar) ?? ""
    }
    return result
  }

  func seperatedOrderCurrencyLetter(from orderCurrency: OrderCurrency) -> String {
    return self.seperatedLetter(from: orderCurrency.ticker)
    + self.seperatedLetter(from: orderCurrency.koreanName)
  }
  
  private func separatedLetterFromSyllable(unicodeScalar: UnicodeScalar) -> String? {
    guard let koreanCharacterSet = CharacterSet.korean else { return nil }

    if !koreanCharacterSet.contains(unicodeScalar) {
      return String(UnicodeScalar(unicodeScalar))
    }

    let index = unicodeScalar.value - initialKoreanIndex
    guard let separatedFirstConsonantLetter = firstConsonantLetter[safe: Int(index / firstConsonantCycle)],
          let separatedMiddleVowelLetter = middleVowelLetter[safe: Int((index % firstConsonantCycle) / middleVowelCycle)],
          var separatedLastConsonantLetter = lastConsonantLetter[safe: Int(index % middleVowelCycle)] else { return nil }

    if let disassembledLastConsonantLetter = separatedDoubledLastConsonantLetter[separatedLastConsonantLetter] {
      separatedLastConsonantLetter = disassembledLastConsonantLetter
    }

    return separatedFirstConsonantLetter + separatedMiddleVowelLetter + separatedLastConsonantLetter
  }
}
