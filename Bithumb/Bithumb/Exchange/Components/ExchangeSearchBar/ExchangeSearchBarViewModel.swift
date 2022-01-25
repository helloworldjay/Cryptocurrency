//
//  ExchangeSearchBarViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

protocol ExchangeSearchBarViewModelLogic {
  var inputText: PublishRelay<String?> { get set }
  var searchButtonTapped: PublishRelay<Void> { get set }
  var orderCurrencyToSearch: Observable<OrderCurrency> { get }
}

final class ExchangeSearchBarViewModel: ExchangeSearchBarViewModelLogic {
  
  // MARK: Properties
  
  var inputText = PublishRelay<String?>()
  var searchButtonTapped = PublishRelay<Void>()
  var orderCurrencyToSearch: Observable<OrderCurrency>
  
  
  // MARK: Initializers
  
  init() {
    self.orderCurrencyToSearch = self.searchButtonTapped
      .withLatestFrom(self.inputText) { $1 ?? "ALL" }
      .map {
        var currency = OrderCurrency.all
        for orderCurrency in OrderCurrency.allCases {
          if orderCurrency.rawValue == $0 {
            currency = orderCurrency
          }
        }
        return currency
      }
      .distinctUntilChanged()
  }
}
