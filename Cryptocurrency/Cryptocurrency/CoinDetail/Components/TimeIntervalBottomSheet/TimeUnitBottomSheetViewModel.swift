//
//  TimeUnitBottomSheetViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/01.
//

import RxRelay
import RxSwift

protocol TimeUnitBottomSheetViewModelLogic {
  var units: [TimeUnit] { get }
  var tapListView: BehaviorRelay<IndexPath> { get }
  var selectedTimeUnit: PublishRelay<TimeUnit> { get }
  var timeUnitBottomSheetCoordinator: TimeUnitBottomSheetCoordinator? { get set }
}

final class TimeUnitBottomSheetViewModel: TimeUnitBottomSheetViewModelLogic {
  
  // MARK: Properties
  
  let units = TimeUnit.allCases
  let tapListView: BehaviorRelay<IndexPath>
  let selectedTimeUnit: PublishRelay<TimeUnit>
  
  var timeUnitBottomSheetCoordinator: TimeUnitBottomSheetCoordinator?
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializaer
  
  init(timeUnit: TimeUnit) {
    let index = self.units.firstIndex(of: timeUnit) ?? 0
    self.tapListView = BehaviorRelay(value: IndexPath(row: index, section: .zero))
    self.selectedTimeUnit = PublishRelay<TimeUnit>()
    
    self.bind()
  }
  
  private func bind() {
    self.tapListView.map {
      self.units[safe: $0.row] ?? .oneMinute
    }
    .bind(to: self.selectedTimeUnit)
    .disposed(by: self.disposeBag)

    self.selectedTimeUnit
      .bind { timeUnit in
        self.timeUnitBottomSheetCoordinator?.dismiss()
      }
      .disposed(by: self.disposeBag)
  }
}
