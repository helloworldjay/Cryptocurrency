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
  let exchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic
  let coinListSortViewModel: CoinListSortViewModelLogic
  let coinListViewModel: CoinListViewModelLogic
  var exchangeCoordinator: ExchangeCoordinator?
  private let orderCurrency = BehaviorSubject<OrderCurrency>(value: .all)
  private let exchangeUseCase: ExchangeUseCaseLogic
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializers

  init(useCase: ExchangeUseCaseLogic) {
    self.exchangeSearchBarViewModel = ExchangeSearchBarViewModel()
    self.coinListSortViewModel = CoinListSortViewModel()
    self.exchangeSegmentedCategoryViewModel = ExchangeSegmentedCategoryViewModel()
    self.coinListViewModel = CoinListViewModel()
    self.exchangeUseCase = useCase

    self.bind()
    self.transition()
  }

  private func bind() {
    self.filteredCellData()
      .bind(to: coinListViewModel.coinListCellData)
      .disposed(by: self.disposeBag)
  }

  private func transition() {
    self.coinListViewModel.selectedOrderCurrency
      .subscribe(onNext: { orderCurrency in
        guard let paymentCurrency = try? self.exchangeSegmentedCategoryViewModel.paymentCurrency.value() else {
          return
        }
        self.exchangeCoordinator?.presentCoinDetailViewController(orderCurrency: orderCurrency,
                                                                  paymentCurrency: paymentCurrency)
      }).disposed(by: self.disposeBag)
  }


  // MARK: Streams

  private func filteredCellData() -> Observable<[CoinListViewCellData]> {
    return Observable.combineLatest(
      self.sortedCellData(),
      self.exchangeSearchBarViewModel.orderCurrenciesToSearch
    ) { sortedCellData, filteredOrderCurrencies in
      return sortedCellData.filter { cellDatum in
        filteredOrderCurrencies.values.contains(cellDatum.ticker)
      }
    }
  }

  private func sortedCellData() -> Observable<[CoinListViewCellData]> {
    return Observable.combineLatest(
      self.coinListCellData(),
      self.coinListSortViewModel.coinListSortCriteria
    ) { cellData, coinListSortCriteria -> [CoinListViewCellData] in
      switch coinListSortCriteria.coinListSortCriterion {
      case .coinName:
        return self.exchangeUseCase.sortByCoinName(coinListCellData: cellData, isDescending: coinListSortCriteria.isDescending)
      case .currentPrice:
        return self.exchangeUseCase.sortByCurrentPrice(coinListCellData: cellData, isDescending: coinListSortCriteria.isDescending)
      case .priceChangedRatio:
        return self.exchangeUseCase.sortByPriceChangedRatio(coinListCellData: cellData, isDescending: coinListSortCriteria.isDescending)
      case .transactionAmount:
        return self.exchangeUseCase.sortByTransactionAmount(coinListCellData: cellData, isDescending: coinListSortCriteria.isDescending)
      }
    }
  }

  private func coinListCellData() -> Observable<[CoinListViewCellData]> {
    return Observable.combineLatest(
      self.orderCurrency,
      self.exchangeSegmentedCategoryViewModel.paymentCurrency,
      self.coinListSortViewModel.coinListSortCriteria
    ) { orderCurrency, paymentCurrency, _ in
      self.exchangeUseCase.fetchTicker(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
    }.flatMap { $0 }
    .map(self.exchangeUseCase.tickerResponse)
    .filter { $0 != nil }
    .map(self.exchangeUseCase.coinListCellData)
  }
}
