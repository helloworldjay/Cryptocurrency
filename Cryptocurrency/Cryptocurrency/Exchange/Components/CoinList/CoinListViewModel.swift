//
//  CoinListViewModel.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift
import Starscream

protocol CoinListViewModelLogic {
  var coinListCellData: PublishSubject<[CoinListViewCellData]> { get }
  var cellData: Driver<[CoinListViewCellData]> { get }
  var selectedOrderCurrency: PublishSubject<OrderCurrency> { get }
  var socketText: PublishRelay<String> { get }
  var socketTickerData: Driver<SocketTickerData?> { get }
  func tickerName(from data: SocketTickerData) -> String?
  func coinListViewCellData(from data: SocketTickerData) -> CoinListViewCellData?
}

final class CoinListViewModel: CoinListViewModelLogic {

  // MARK: Properties

  let coinListCellData = PublishSubject<[CoinListViewCellData]>()
  let cellData: Driver<[CoinListViewCellData]>
  let selectedOrderCurrency = PublishSubject<OrderCurrency>()
  let socketText = PublishRelay<String>()
  let socketTickerData: Driver<SocketTickerData?>
  private let disposeBag = DisposeBag()


  // MARK: Initializers

  init() {
    self.cellData = self.coinListCellData
      .asDriver(onErrorJustReturn: [])

    self.socketTickerData = self.socketText
      .map {
        return $0.replacingOccurrences(of: "\\", with: "").data(using: .utf8)
      }.filter { $0 != nil }
      .map {
        return try? JSONDecoder().decode(SocketTickerResponse.self, from: $0!)
      }.filter { $0 != nil }
      .map {
        $0!.content
      }.asDriver(onErrorJustReturn: nil)

    WebSocketManager.shared.socket?.delegate = self
  }

  func tickerName(from data: SocketTickerData) -> String? {
    guard let ticker = data.symbol.split(separator: "_").first else { return nil }
    return String(ticker)
  }

  func coinListViewCellData(from data: SocketTickerData) -> CoinListViewCellData? {
    guard let ticker = self.tickerName(from: data) else { return nil }
    return CoinListViewCellData(
      coinName: OrderCurrency.search(with: ticker).koreanName,
      ticker: ticker,
      currentPrice: data.closePrice,
      priceChangedRatio: data.changeRate,
      priceDifference: data.changeAmount,
      transactionAmount: data.value
    )
  }
}


// MARK: - WebSocket Delegate Logic

extension CoinListViewModel: WebSocketDelegate {
  func didReceive(event: WebSocketEvent, client: WebSocket) {
    switch event {
    case .connected(let headers):
      self.sendSocketTickerMessage()
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

  private func sendSocketTickerMessage() {
    WebSocketManager.shared.sendMessage(
      socketType: SocketType.ticker,
      symbols: WebSocketManager.shared.generateAllSymbol(with: .krw),
      tickType: "24H"
    )
  }
}
