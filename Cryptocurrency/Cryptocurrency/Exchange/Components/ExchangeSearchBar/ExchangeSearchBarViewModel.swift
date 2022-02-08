//
//  ExchangeSearchBarViewModel.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

protocol ExchangeSearchBarViewModelLogic {
  var inputText: PublishRelay<String> { get }
  var orderCurrenciesToSearch: Observable<[OrderCurrency : String]> { get }
}

final class ExchangeSearchBarViewModel: ExchangeSearchBarViewModelLogic {
  
  // MARK: Properties
  
  let inputText = PublishRelay<String>()
  let orderCurrenciesToSearch: Observable<[OrderCurrency : String]>


  // MARK: Initializers
  
  init() {
    self.orderCurrenciesToSearch = self.inputText
      .map { $0.uppercased() }
      .map(OrderCurrency.filteredCurrencies)
      .distinctUntilChanged()
  }
}
