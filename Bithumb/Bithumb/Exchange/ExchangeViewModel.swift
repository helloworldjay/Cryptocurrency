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
  var segmentedCategoryViewModel: SegmentedCategoryViewModelLogic { get }
  var exchangeCoordinator: ExchangeCoordinator? { get set }
}

final class ExchangeViewModel: ExchangeViewModelLogic {
  
  // MARK: Properties
  
  let exchangeSearchBarViewModel: ExchangeSearchBarViewModelLogic
  let coinListViewModel: CoinListViewModelLogic
  let segmentedCategoryViewModel: SegmentedCategoryViewModelLogic
  var exchangeCoordinator: ExchangeCoordinator?
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializers
  
  init(useCase: ExchangeUseCaseLogic) {
    self.exchangeSearchBarViewModel = ExchangeSearchBarViewModel()
    self.coinListViewModel = CoinListViewModel()
    self.segmentedCategoryViewModel = SegmentedCategoryViewModel()

    let filteredOrderCurrencies = self.exchangeSearchBarViewModel.orderCurrenciesToSearch

    let result = self.segmentedCategoryViewModel.paymentCurrency
      .flatMapLatest {
        useCase.fetchTicker(orderCurrency: .all, paymentCurrency: $0)
      }

    let cellData = result
      .map(useCase.tickerResponse)
      .filter { $0 != nil }
      .map(useCase.coinListCellData)
    
    let filteredCellData = Observable.combineLatest(cellData, filteredOrderCurrencies) { cellData, filteredOne in
      cellData.filter { cellDatum in
        filteredOne.values.contains(cellDatum.ticker)
      }
    }

    filteredCellData
      .bind(to: coinListViewModel.coinListCellData)
      .disposed(by: disposeBag)

    self.coinListViewModel.selectedOrderCurrency
      .subscribe(on: MainScheduler.instance)
      .subscribe {
        self.exchangeCoordinator?.presentCoinDetailViewController(orderCurrency: $0)
      }.disposed(by: self.disposeBag)
  }
}
