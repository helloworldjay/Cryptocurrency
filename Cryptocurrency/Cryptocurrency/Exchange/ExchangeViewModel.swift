//
//  ExchangeViewModel.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

protocol ExchangeViewModelLogic {
  var exchangeSearchBarViewModel: ExchangeSearchBarViewModelLogic { get }
  var coinListViewModel: CoinListViewModelLogic { get }
  var coinListSortViewModel: CoinListSortViewModelLogic { get }
  var exchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic { get }
  var exchangeCoordinator: ExchangeCoordinator? { get set }
}

final class ExchangeViewModel: ExchangeViewModelLogic {
  
  // MARK: Properties
  
  let exchangeSearchBarViewModel: ExchangeSearchBarViewModelLogic
  let coinListViewModel: CoinListViewModelLogic
  let coinListSortViewModel: CoinListSortViewModelLogic
  let exchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic
  var exchangeCoordinator: ExchangeCoordinator?
  private let orderCurrency = BehaviorSubject<OrderCurrency>(value: .all)
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializers
  
  init(useCase: ExchangeUseCaseLogic) {
    self.exchangeSearchBarViewModel = ExchangeSearchBarViewModel()
    self.coinListViewModel = CoinListViewModel()
    self.coinListSortViewModel = CoinListSortViewModel()
    self.exchangeSegmentedCategoryViewModel = ExchangeSegmentedCategoryViewModel()

    let result = Observable.combineLatest(
      self.orderCurrency,
      self.exchangeSegmentedCategoryViewModel.paymentCurrency,
      self.coinListSortViewModel.coinListSortCriteria
    ) { orderCurrency, paymentCurrency, _ in
      useCase.fetchTicker(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency) }
      .flatMap { $0 }

    let cellData = result
      .map(useCase.tickerResponse)
      .filter { $0 != nil }
      .map(useCase.coinListCellData)

    let sortedCellData = Observable.combineLatest(
      cellData,
      self.coinListSortViewModel.coinListSortCriteria
    ) { cellData, coinListSortCriteria -> [CoinListViewCellData] in
      switch coinListSortCriteria.coinListSortCriterion {
      case .coinName:
        return useCase.sortByCoinName(coinListCellData: cellData, isDescending: coinListSortCriteria.isDescending)
      case .currentPrice:
        return useCase.sortByCurrentPrice(coinListCellData: cellData, isDescending: coinListSortCriteria.isDescending)
      case .priceChangedRatio:
        return useCase.sortByPriceChangedRatio(coinListCellData: cellData, isDescending: coinListSortCriteria.isDescending)
      case .transactionAmount:
        return useCase.sortByTransactionAmount(coinListCellData: cellData, isDescending: coinListSortCriteria.isDescending)
      }
    }

    let filteredCellData = Observable.combineLatest(
      sortedCellData,
      self.exchangeSearchBarViewModel.orderCurrenciesToSearch
    ) { sortedCellData, filteredOrderCurrencies in
      return sortedCellData.filter { cellDatum in
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
