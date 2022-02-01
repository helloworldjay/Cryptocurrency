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
  let tapSelctTimeIntervalButton = PublishRelay<Void>()
  var coinDetailCoordinator: CoinDetailCoordinator?
    
  private let disposeBag = DisposeBag()
  
  init() {
    self.tapSelctTimeIntervalButton
      .bind {
        self.coinDetailCoordinator?.presentTimeIntervalBottomSheet(with: self.selectedTimeInterval.value)
      }
      .disposed(by: self.disposeBag)
  }
}
