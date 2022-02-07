//
//  OrderCurrencyTests.swift
//  BithumbTests
//
//  Created by Seungjin Baek on 2022/02/05.
//

import XCTest
@testable import Cryptocurrency

import Nimble

class OrderCurrencyTests: XCTestCase {

  func test_특정_문자열에_매칭되는_딕셔너리를_정상적으로_반환() {
    //given
    let letter = "BTC"
    let expectedDictionary = [OrderCurrency.btc : "BTC"]

    //when
    let result = OrderCurrency.filteredCurrencies(with: letter)

    //then
    expect(result).to(equal(expectedDictionary))
  }
}
