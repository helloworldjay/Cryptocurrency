//
//  SegmentedCategoryViewTests.swift
//  CryptocurrencyTests
//
//  Created by Seungjin Baek on 2022/01/30.
//

import XCTest
@testable import Cryptocurrency

import Nimble

class SegmentedCategoryViewTests: XCTestCase {

  var sut: ExchangeSegmentedCategoryView!

  override func setUp() {
    self.sut = ExchangeSegmentedCategoryView()
  }

  func test_index를_이용해_Segment의_PaymentCurrency_타입을_확인() {
    //given
    let firstIndex = 0
    let secondIndex = 1

    //when
    let firstResult = ExchangeSegmentedCategoryView.SegmentedViewIndex
      .findPaymentCurrency(with: firstIndex)
    let secondResult = ExchangeSegmentedCategoryView.SegmentedViewIndex
      .findPaymentCurrency(with: secondIndex)

    //then
    expect(firstResult).to(equal(PaymentCurrency.krw))
    expect(secondResult).to(equal(PaymentCurrency.btc))
  }
}
