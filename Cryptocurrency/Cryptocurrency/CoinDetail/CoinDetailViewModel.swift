//
//  CoinDetailViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/01.
//

import RxRelay
import RxSwift
import Starscream

protocol CoinDetailViewModelLogic {
  var selectedTimeUnit: BehaviorRelay<TimeUnit> { get }
  var tapSelectTimeUnitButton: PublishRelay<Void> { get }
  var coinChartViewModel: CoinChartViewModel { get }
  var currentPriceStatusViewModel: CurrentPriceStatusViewModel { get }
  var coinDetailSegmentedCategoryViewModel: CoinDetailSegmentedCategoryViewModel { get }
  var transactionSheetViewModel: TransactionSheetViewModel { get }
  var orderBookListViewModel: OrderBookListViewModel { get }
  var openingPrice: PublishRelay<Double> { get }
  var coinDetailCoordinator: CoinDetailCoordinator? { get set }
  var socketText: PublishRelay<String> { get }
}

final class CoinDetailViewModel: CoinDetailViewModelLogic {
  
  // MARK: Properties
  
  let selectedTimeUnit = BehaviorRelay(value: TimeUnit.oneMinute)
  let tapSelectTimeUnitButton = PublishRelay<Void>()
  let coinChartViewModel = CoinChartViewModel()
  let currentPriceStatusViewModel = CurrentPriceStatusViewModel()
  let coinDetailSegmentedCategoryViewModel = CoinDetailSegmentedCategoryViewModel()
  let transactionSheetViewModel = TransactionSheetViewModel()
  let orderBookListViewModel = OrderBookListViewModel()
  let openingPrice = PublishRelay<Double>()
  var coinDetailCoordinator: CoinDetailCoordinator?
  let socketText = PublishRelay<String>()
  private let disposeBag = DisposeBag()


  // MARK: Initializer

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

    let transactionHistoryResult = useCase.fetchTransactionHistory(orderCurrency: orderCurrency,
                                                                   paymentCurrency: paymentCurrency)

    let transactionHistoryResponse = transactionHistoryResult
      .map(useCase.response)
      .filter { $0 != nil }
      .map { $0! }

    let transactionSheetViewCellData = transactionHistoryResponse
      .map(useCase.transactionSheetViewCellData)
      .asObservable()

    WebSocketManager.shared.socket?.delegate = self

    let socketTickerResponse = self.socketText
      .map { $0.data(using: .utf8) }
      .filter { $0 != nil }
      .map { useCase.socketResponse(with: $0!, type: SocketTickerResponse.self) }
    
    socketTickerResponse
      .filter { $0 != nil }
      .map { useCase.coinPriceData(with: $0!) }
      .bind(to: self.currentPriceStatusViewModel.coinPriceData)
      .disposed(by: self.disposeBag)

    let socketTransactionResponse = self.socketText
      .map { $0.data(using: .utf8) }
      .filter { $0 != nil }
      .map { useCase.socketResponse(with: $0!, type: SocketTransactionResponse.self) }
    
    let socketTransactionSheetViewCellData = socketTransactionResponse
      .filter { $0 != nil }
      .map { useCase.transactionSheetViewCellData(with: $0!) }

    Observable.merge(transactionSheetViewCellData, socketTransactionSheetViewCellData)
      .observe(on: ConcurrentMainScheduler.instance)
      .scan([TransactionSheetViewCellData]()) { cellData, action in
        return action + cellData
      }.bind(to: self.transactionSheetViewModel.transactionSheetViewCellData)
      .disposed(by: self.disposeBag)
  }
}


// MARK: - WebSocket Delegate Logic

extension CoinDetailViewModel: WebSocketDelegate {
  func didReceive(event: WebSocketEvent, client: WebSocket) {
    switch event {
    case .connected(let headers):
      client.write(string: "이름")
      print("websocket is connected: \(headers)")
    case .disconnected(let reason, let code):
      print("websocket is disconnected: \(reason) with code: \(code)")
    case .text(let text):
      Observable.just(text)
        .bind(to: self.socketText)
        .disposed(by: self.disposeBag)
    case .binary(let data):
      print("Received data: \(data.count)")
    case .ping(_):
      break
    case .pong(_):
      break
    case .viabilityChanged(_):
      break
    case .reconnectSuggested(_):
      break
    case .cancelled:
      print("websocket is canceled")
    case .error(let error):
      print("websocket is error = \(error!)")
    }
  }
}
