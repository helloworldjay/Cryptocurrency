//
//  TimeIntervalViewModel.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/01.
//

import RxRelay
import RxSwift

protocol TimeIntervalViewModelLogic {
  var intervals: [TimeInterval] { get }
  var tapListView: BehaviorRelay<IndexPath> { get }
  var selectedTimeInterval: BehaviorRelay<TimeInterval> { get }
  var timeIntervalBottomSheetCoordinator: TimeIntervalBottomSheetCoordinator? { get set }
}

final class TimeIntervalViewModel: TimeIntervalViewModelLogic {
  
  // MARK: Properties
  
  let intervals = TimeInterval.allCases
  let tapListView: BehaviorRelay<IndexPath>
  let selectedTimeInterval: BehaviorRelay<TimeInterval>
  
  var timeIntervalBottomSheetCoordinator: TimeIntervalBottomSheetCoordinator?
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializaer
  
  init(timeInterval: TimeInterval) {
    let index = self.intervals.firstIndex(of: timeInterval) ?? 0
    self.tapListView = BehaviorRelay(value: IndexPath(row: index, section: .zero))
    self.selectedTimeInterval = BehaviorRelay(value: timeInterval)
    
    self.bind()
  }
  
  private func bind() {
    self.tapListView.map {
      self.intervals[safe: $0.row] ?? .oneMinute
    }
    .bind(to: self.selectedTimeInterval)
    .disposed(by: self.disposeBag)

    self.selectedTimeInterval
      .skip(1)
      .bind { timeInterval in
        self.timeIntervalBottomSheetCoordinator?.dismiss()
      }
      .disposed(by: self.disposeBag)
  }
}
