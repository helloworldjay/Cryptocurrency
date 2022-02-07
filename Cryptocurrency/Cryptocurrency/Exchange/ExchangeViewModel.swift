//
//  ExchangeViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

protocol ExchangeViewModelLogic {
  var exchangeSearchBarViewModel: ExchangeSearchBarViewModelLogic { get }
  var coinListViewModel: CoinListViewModelLogic { get }
  var exchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic { get }
  var exchangeCoordinator: ExchangeCoordinator? { get set }
}

final class ExchangeViewModel: ExchangeViewModelLogic {
  
  // MARK: Properties
  
  let exchangeSearchBarViewModel: ExchangeSearchBarViewModelLogic
  let coinListViewModel: CoinListViewModelLogic
  let exchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic
  var exchangeCoordinator: ExchangeCoordinator?
  private let orderCurrency = BehaviorSubject<OrderCurrency>(value: .all)
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializers
  
  init(useCase: ExchangeUseCaseLogic) {
    self.exchangeSearchBarViewModel = ExchangeSearchBarViewModel()
    self.coinListViewModel = CoinListViewModel()
    self.exchangeSegmentedCategoryViewModel = ExchangeSegmentedCategoryViewModel()

    let result = Observable.combineLatest(
      self.orderCurrency,
      self.exchangeSegmentedCategoryViewModel.paymentCurrency
    ) { useCase.fetchTicker(orderCurrency: $0, paymentCurrency: $1) }
      .flatMap { $0 }

    let cellData = result
      .map(useCase.tickerResponse)
      .filter { $0 != nil }
      .map(useCase.coinListCellData)

    let filteredCellData = Observable.combineLatest(
      cellData,
      self.exchangeSearchBarViewModel.orderCurrenciesToSearch
    ) { cellData, filteredOrderCurrencies in
      return cellData.filter { cellDatum in
        filteredOrderCurrencies.values.contains(cellDatum.ticker)
      }
    }

    filteredCellData
      .bind(to: coinListViewModel.coinListCellData)
      .disposed(by: disposeBag)

    self.coinListViewModel.selectedOrderCurrency
      .subscribe(onNext: { orderCurrency in
        guard let paymentCurrency = try? self.exchangeSegmentedCategoryViewModel.paymentCurrency.value() else {
          return
        }
        self.exchangeCoordinator?.presentCoinDetailViewController(orderCurrency: orderCurrency,
                                                                  paymentCurrency: paymentCurrency)
      }).disposed(by: self.disposeBag)
  }
}
