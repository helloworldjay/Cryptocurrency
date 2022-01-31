//
//  SegmentedCategoryViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/30.
//

import Foundation

import RxSwift

protocol SegmentedCategoryViewModelLogic {
  var paymentCurrency: BehaviorSubject<PaymentCurrency> { get set }
}

final class SegmentedCategoryViewModel: SegmentedCategoryViewModelLogic {
  var paymentCurrency = BehaviorSubject<PaymentCurrency>(value: .krw)
}
