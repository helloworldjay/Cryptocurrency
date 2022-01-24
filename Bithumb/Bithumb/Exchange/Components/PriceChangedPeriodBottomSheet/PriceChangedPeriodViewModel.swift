//
//  PriceChangedPeriodViewModel.swift
//  Bithumb
//
//  Created by 이영우 on 2022/01/24.
//

import UIKit

import RxRelay
import RxSwift

final class PriceChangedPeriodViewModel {
  
  // MARK: Properties
  
  let periods = Period.allCases
  let tapListView: BehaviorRelay<IndexPath>
  var selectedPeriod: BehaviorRelay<Period>
  
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializer
  
  init(selectedPeriod: Period) {
    let index = Period.allCases.firstIndex(of: selectedPeriod) ?? 0
    self.tapListView = BehaviorRelay(value: IndexPath(row: index, section: .zero))
    self.selectedPeriod = BehaviorRelay(value: selectedPeriod)
    
    self.bind()
  }
  
  private func bind() {
    self.tapListView.map {
      Period.allCases[$0.row]
    }
    .bind(to: self.selectedPeriod)
    .disposed(by: self.disposeBag)
  }
}
