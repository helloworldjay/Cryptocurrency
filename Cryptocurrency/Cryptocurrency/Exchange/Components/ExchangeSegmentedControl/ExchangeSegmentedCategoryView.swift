//
//  ExchangeSegmentedCategoryView.swift
//  Cryptocurrency
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
    case favorite = 2
    
    var matchedCurrency: PaymentCurrency? {
      switch self {
      case .krw:
        return PaymentCurrency.krw
      case .btc:
        return PaymentCurrency.btc
      case .favorite:
        return nil
      }
    }
    
    static func findPaymentCurrency(with index: Int) -> PaymentCurrency? {
      guard let paymentCurrency = SegmentedViewIndex.allCases
              .filter({ $0.rawValue == index })
              .map({ $0.matchedCurrency }).first else { return .krw }
      return paymentCurrency
    }

    static func findCategory(with index: Int) -> Self {
      guard let category = SegmentedViewIndex.allCases
              .filter({ $0.rawValue == index })
              .first else { return .krw }
      return category
    }
  }
  
  
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  
  
  // MARK: Bind
  
  func bind(viewModel: ExchangeSegmentedCategoryViewModelLogic) {
    self.segmentedControl.rx.selectedSegmentIndex
      .filter { $0 < SegmentedViewIndex.allCases.count }
      .map { SegmentedViewIndex.findPaymentCurrency(with: $0) }
      .filter { $0 != nil } 
      .bind(to: viewModel.paymentCurrency)
      .disposed(by: self.disposeBag)

    self.segmentedControl.rx.selectedSegmentIndex
      .map { SegmentedViewIndex.findCategory(with: $0) }
      .bind(to: viewModel.category)
      .disposed(by: self.disposeBag)
  }
}
