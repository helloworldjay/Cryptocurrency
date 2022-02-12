//
//  CoinDetailViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/01.
//

import RxRelay
import RxSwift

final class CoinDetailViewModel {
  
  // MARK: Properties
  
  let selectedTimeUnit = BehaviorRelay(value: TimeUnit.oneMinute)
  let tapSelectTimeUnitButton = PublishRelay<Void>()
  let coinChartViewModel = CoinChartViewModel()
  let currentPriceStatusViewModel = CurrentPriceStatusViewModel()
  let coinDetailSegmentedCategoryViewModel = CoinDetailSegmentedCategoryViewModel()
  let orderBookListViewModel = OrderBookListViewModel()
  let openingPrice = PublishRelay<Double>()
  var coinDetailCoordinator: CoinDetailCoordinator?

  private let disposeBag = DisposeBag()

  init(useCase: CoinDetailUseCaseLogic = CoinDetailUseCase(),
       orderCurrency: OrderCurrency,
       paymentCurrency: PaymentCurrency) {
    self.tapSelectTimeUnitButton
      .bind { [weak self] in
        guard let self = self else { return }
        self.coinDetailCoordinator?.presentTimeUnitBottomSheet(with: self.selectedTimeUnit.value)
      }
      .disposed(by: self.disposeBag)
    
    let candleStickResult = self.selectedTimeUnit
      .flatMapLatest {
        useCase.fetchCandleStick(orderCurrency: orderCurrency,
                                 paymentCurrency: paymentCurrency,
                                 timeUnit: $0)
      }
    
    let chartData = candleStickResult
      .map(useCase.response)
      .filter { $0 != nil }
      .map(useCase.chartData)
    
    chartData
      .bind(to: self.coinChartViewModel.chartData)
      .disposed(by: self.disposeBag)
    
    let tickerResult = useCase.fetchTicker(orderCurrency: orderCurrency,
                                           paymentCurrency: paymentCurrency)

    let tickerResponse = tickerResult
      .map(useCase.response)
      .filter { $0 != nil }

    let tickerData = tickerResponse
      .map(useCase.tickerData)
      .filter { $0 != nil }
      .map { $0! }

    tickerData
      .asObservable()
      .bind(to: self.currentPriceStatusViewModel.coinPriceData)
      .disposed(by: self.disposeBag)

    tickerData
      .map(useCase.openingPrice)
      .asObservable()
      .bind(to: self.openingPrice)
      .disposed(by: self.disposeBag)

    let orderBookResult = useCase.fetchOrderBook(orderCurrency: orderCurrency,
                                                 paymentCurrency: paymentCurrency)

    let orderBookResponse = orderBookResult
      .map(useCase.response)
      .filter { $0 != nil }
      .map { $0! }
      .asObservable()

    Observable.combineLatest(
      orderBookResponse,
      self.openingPrice
    ).map { (response, openingPrice) in
      let bids = useCase.orderBookListViewCellData(with: response, category: .bid, openingPrice: openingPrice)
      let asks = useCase.orderBookListViewCellData(with: response, category: .ask, openingPrice: openingPrice)
      return asks + bids
    }
    .bind(to: self.orderBookListViewModel.orderBookListViewCellData)
    .disposed(by: self.disposeBag)
  }
}
