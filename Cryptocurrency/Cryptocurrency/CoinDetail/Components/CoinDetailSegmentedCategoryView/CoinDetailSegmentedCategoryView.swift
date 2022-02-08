//
//  CoinDetailSegmentedCategoryView.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/07.
//

import Foundation

import RxCocoa
import RxSwift

final class CoinDetailSegmentedCategoryView: SegmentedCategoryView {
  
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializer
  
  init() {
    super.init(items: ["호가", "차트", "시세"], fontSize: 14)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Bind
  
  func bind(viewModel: CoinDetailSegmentedCategoryViewModelLogic) {
    self.segmentedControl.rx.selectedSegmentIndex
      .map { CoinDetailCategory.findCategory(with: $0) }
      .bind(to: viewModel.category)
      .disposed(by: self.disposeBag)
  }
}
