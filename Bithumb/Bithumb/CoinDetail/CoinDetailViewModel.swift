//
//  CoinDetailViewModel.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/01.
//

import RxRelay
import RxSwift

final class CoinDetailViewModel {
  
  // MARK: Properties
  
  let selectedTimeInterval = BehaviorRelay(value: TimeInterval.oneMinute)
  let tapSelectTimeIntervalButton = PublishRelay<Void>()
  let coinChartViewModel = CoinChartViewModel()
  var coinDetailCoordinator: CoinDetailCoordinator?
    
  private let disposeBag = DisposeBag()
  
  init() {
    self.tapSelectTimeIntervalButton
      .bind {
        self.coinDetailCoordinator?.presentTimeIntervalBottomSheet(with: self.selectedTimeInterval.value)
      }
      .disposed(by: self.disposeBag)
  }
}
