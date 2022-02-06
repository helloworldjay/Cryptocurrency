//
//  ExchangeSegmentedCategoryView.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/02/06.
//

import UIKit

import RxCocoa
import RxSwift

final class ExchangeSegmentedCategoryView: SegmentedCategoryView {
  
  // MARK: Register Segmented Index Matching to PaymentCurrency
  
  enum SegmentedViewIndex: Int, CaseIterable {
    case krw = 0
    case btc = 1
    
    var matchedCurrency: PaymentCurrency {
      switch self {
      case .krw:
        return PaymentCurrency.krw
      case .btc:
        return PaymentCurrency.btc
      }
    }
    
    static func findPaymentCurrency(with index: Int) -> PaymentCurrency {
      guard let paymentCurrency = SegmentedViewIndex.allCases
              .filter({ $0.rawValue == index })
              .map({ $0.matchedCurrency }).first else { return .krw }
      return paymentCurrency
    }
  }
  
  
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  
  
  // MARK: Bind
  
  func bind(viewModel: ExchangeSegmentedCategoryViewModelLogic) {
    self.segmentedControl.rx.selectedSegmentIndex
      .filter { $0 < SegmentedViewIndex.allCases.count }
      .map { SegmentedViewIndex.findPaymentCurrency(with: $0) }
      .bind(to: viewModel.paymentCurrency)
      .disposed(by: self.disposeBag)
  }
}
