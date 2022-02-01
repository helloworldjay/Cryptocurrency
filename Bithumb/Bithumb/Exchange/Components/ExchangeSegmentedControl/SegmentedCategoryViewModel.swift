//
//  SegmentedCategoryViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/30.
//

import Foundation

import RxSwift

protocol SegmentedCategoryViewModelLogic {
  var paymentCurrency: BehaviorSubject<PaymentCurrency> { get }
}

final class SegmentedCategoryViewModel: SegmentedCategoryViewModelLogic {
  let paymentCurrency = BehaviorSubject<PaymentCurrency>(value: .krw)
}
