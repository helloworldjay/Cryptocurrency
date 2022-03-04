//
//  SegmentedCategoryViewModel.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/30.
//

import RxSwift

protocol ExchangeSegmentedCategoryViewModelLogic {
  var paymentCurrency: BehaviorSubject<PaymentCurrency> { get }
}

final class ExchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic {
  let paymentCurrency = BehaviorSubject<PaymentCurrency>(value: .krw)
}
