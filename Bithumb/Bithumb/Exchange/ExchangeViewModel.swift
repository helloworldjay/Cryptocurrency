//
//  ExchangeViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

protocol ExchangeViewModelLogic {
  var exchangeSearchBarViewModel: ExchangeSearchBarViewModel { get set }
  var coinListViewModel: CoinListViewModel { get set }
  var exchangeCoordinator: ExchangeCoordinator? { get set }
}

final class ExchangeViewModel: ExchangeViewModelLogic {
  
  // MARK: Properties
  
  var exchangeSearchBarViewModel = ExchangeSearchBarViewModel()
  var coinListViewModel = CoinListViewModel()
  var exchangeCoordinator: ExchangeCoordinator?
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializers
  
  init(useCase: ExchangeUseCaseLogic) {
    let result = self.exchangeSearchBarViewModel.orderCurrencyToSearch
      .flatMapLatest { currency in
        useCase.fetchTicker(orderCurrency: currency, paymentCurrency: .krw)
      }
    
    let cellData = result
      .map(useCase.tickerResponse)
      .filter { $0 != nil }
      .map(useCase.coinListCellData)
    
    cellData
      .bind(to: coinListViewModel.coinListCellData)
      .disposed(by: disposeBag)

    self.coinListViewModel.selectedOrderCurrency
      .subscribe(on: MainScheduler.instance)
      .subscribe {
        self.exchangeCoordinator?.presentCoinDetailViewController(orderCurrency: $0)
      }.disposed(by: self.disposeBag)
  }
}
