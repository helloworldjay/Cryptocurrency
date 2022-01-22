//
//  ExchangeSearchBarViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

final class ExchangeSearchBarViewModel {
  
  // MARK: Properties
  
  let inputText = PublishRelay<String>()
  let searchButtonTapped = PublishRelay<Void>()
  let queryText: Observable<String>
  
  
  // MARK: Initializers
  
  init() {
    self.queryText = self.searchButtonTapped
      .withLatestFrom(self.inputText)
      .filter { !$0.isEmpty }
      .distinctUntilChanged()
  }
}
