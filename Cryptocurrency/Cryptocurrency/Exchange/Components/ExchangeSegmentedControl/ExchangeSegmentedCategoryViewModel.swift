//
//  SegmentedCategoryViewModel.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/30.
//

import Foundation

import RxSwift
import RxRelay

protocol ExchangeSegmentedCategoryViewModelLogic {
  var paymentCurrency: BehaviorSubject<PaymentCurrency?> { get }
  var category: BehaviorRelay<ExchangeSegmentedCategoryView.SegmentedViewIndex> { get }
}

final class ExchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic {
  let paymentCurrency = BehaviorSubject<PaymentCurrency?>(value: .krw)
  let category = BehaviorRelay<ExchangeSegmentedCategoryView.SegmentedViewIndex>(value: .krw)
}
