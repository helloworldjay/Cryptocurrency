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
  var favoriteGridViewModel: FavoriteGridViewModel { get }
  var coinListSortViewModel: CoinListSortViewModelLogic { get }
  var exchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic { get }
  var viewWillAppear: PublishSubject<Void> { get }
  var exchangeCoordinator: ExchangeCoordinator? { get set }
}

final class ExchangeViewModel: ExchangeViewModelLogic {
  
  // MARK: Properties
  
  let exchangeSearchBarViewModel: ExchangeSearchBarViewModelLogic
  let coinListViewModel: CoinListViewModelLogic
  let favoriteGridViewModel: FavoriteGridViewModel
  let coinListSortViewModel: CoinListSortViewModelLogic
  let exchangeSegmentedCategoryViewModel: ExchangeSegmentedCategoryViewModelLogic
  let viewWillAppear = PublishSubject<Void>()
  var exchangeCoordinator: ExchangeCoordinator?
  private let orderCurrency = BehaviorSubject<OrderCurrency>(value: .all)
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializers
  
  init(useCase: ExchangeUseCaseLogic) {
    self.exchangeSearchBarViewModel = ExchangeSearchBarViewModel()
    self.coinListViewModel = CoinListViewModel()
    self.favoriteGridViewModel = FavoriteGridViewModel()
    self.coinListSortViewModel = CoinListSortViewModel()
    self.exchangeSegmentedCategoryViewModel = ExchangeSegmentedCategoryViewModel()

    let result = Observable.combineLatest(
      self.orderCurrency,
      self.exchangeSegmentedCategoryViewModel.paymentCurrency,
      self.coinListSortViewModel.coinListSortCriteria
    ) { orderCurrency, paymentCurrency, _ in
      useCase.fetchTicker(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency!) }
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
      .bind(to: self.coinListViewModel.coinListCellData)
      .disposed(by: self.disposeBag)

    let userDefaultsData = Observable.combineLatest(self.viewWillAppear, self.exchangeSegmentedCategoryViewModel.category) { _, category -> [CoinItemCurrency] in
      var retrivedFavorites: [CoinItemCurrency] = []
      PersistenceManager.retrieveFavorites {
        switch $0 {
        case .success(let favorite):
          retrivedFavorites = favorite
        case .failure(let error):
          print(error)
        }
      }
      return retrivedFavorites
    }

    let favoriteCellData = userDefaultsData
      .map (useCase.favoriteGridCellData)

    favoriteCellData
      .bind(to: self.favoriteGridViewModel.favoriteGridCellData)
      .disposed(by: self.disposeBag)

    self.coinListViewModel.selectedOrderCurrency
      .subscribe(onNext: { orderCurrency in
        guard let paymentCurrency = try? self.exchangeSegmentedCategoryViewModel.paymentCurrency.value() else {
          return
        }
        self.exchangeCoordinator?.presentCoinDetailViewController(orderCurrency: orderCurrency,
                                                                  paymentCurrency: paymentCurrency)
      }).disposed(by: self.disposeBag)

    self.favoriteGridViewModel.selectedCellData
      .subscribe(onNext: {
        self.exchangeCoordinator?.presentCoinDetailViewController(orderCurrency: $0.orderCurrency, paymentCurrency: $0.paymentCurrency)
      })
      .disposed(by: self.disposeBag)
  }
}
