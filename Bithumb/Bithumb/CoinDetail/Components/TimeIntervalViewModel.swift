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
}

final class TimeIntervalViewModel: TimeIntervalViewModelLogic {
  
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  let intervals = TimeInterval.allCases
  let tapListView: BehaviorRelay<IndexPath>
  let selectedTimeInterval: BehaviorRelay<TimeInterval>
  
  
  // MARK: Initializaer
  
  init() {
    let index = self.intervals.firstIndex(of: .oneMinute) ?? 0
    self.tapListView = BehaviorRelay(value: IndexPath(row: index, section: .zero))
    self.selectedTimeInterval = BehaviorRelay(value: .oneMinute)
    
    self.bind()
  }
  
  private func bind() {
    self.tapListView.map {
      self.intervals[safe: $0.row] ?? .oneMinute
    }
    .bind(to: self.selectedTimeInterval)
    .disposed(by: self.disposeBag)
  }
}
