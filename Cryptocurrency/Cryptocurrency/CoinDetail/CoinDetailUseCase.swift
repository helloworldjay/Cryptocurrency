//
//  CoinDetailUseCase.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation

import RxSwift

protocol CoinDetailUseCaseLogic {
  func fetchTicker(orderCurrency: OrderCurrency,
                   paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>>
  func fetchCandleStick(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>>
  func fetchOrderBook(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<OrderBookResponse, APINetworkError>>
  func fetchTransactionHistory(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<TransactionHistoryResponse, APINetworkError>>
  func response<T: Decodable>(result: Result<T, APINetworkError>) -> T?
  func tickerData(response: AllTickerResponse?) -> CoinPriceData?
  func openingPrice(of data: CoinPriceData) -> Double
  func chartData(response: CandleStickResponse?) -> [ChartData]
  func orderBookListViewCellData(with response: OrderBookResponse, category: OrderBookCategory, openingPrice: Double) -> [OrderBookListViewCellData]
  func transactionSheetViewCellData(response: TransactionHistoryResponse) -> [TransactionSheetViewCellData]
}

final class CoinDetailUseCase: CoinDetailUseCaseLogic {
  
  // MARK: Properties
  
  let network: NetworkManagerLogic
  
  
  // MARK: Initializer
  
  init(network: NetworkManagerLogic = NetworkManager()) {
    self.network = network
  }
  
  
  // MARK: Network Logic
  
  func fetchTicker(orderCurrency: OrderCurrency,
                   paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>> {
    return self.network.fetchTickerData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
  }

  func fetchCandleStick(orderCurrency: OrderCurrency,
                        paymentCurrency: PaymentCurrency,
                        timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>> {
    return self.network.fetchCandleStickData(orderCurrency: orderCurrency,
                                        paymentCurrency: paymentCurrency,
                                        timeUnit: timeUnit)
  }

  func fetchOrderBook(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<OrderBookResponse, APINetworkError>> {
    return self.network.fetchOrderBookData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
  }

  func fetchTransactionHistory(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<TransactionHistoryResponse, APINetworkError>> {
    return self.network.fetchTransactionHistoryData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
  }

  func response<T: Decodable>(result: Result<T, APINetworkError>) -> T? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }

  func tickerData(response: AllTickerResponse?) -> CoinPriceData? {
    guard let data = response?.data.first else {
      return nil
    }
    return (
      CoinPriceData(
        currentPrice: data.value.closingPrice,
        priceChangedRatio: data.value.fluctateRate24H,
        priceDifference: data.value.fluctate24H
      )
    )
  }

  func openingPrice(of data: CoinPriceData) -> Double {
    guard let currentPrice = Double(data.currentPrice),
          let priceDifference = Double(data.priceDifference) else {
            return 0
          }
    return currentPrice - priceDifference
  }

  func chartData(response: CandleStickResponse?) -> [ChartData] {
    guard let response = response else {
      return []
    }
    return response.chartData
  }
  
  func orderBookListViewCellData(with response: OrderBookResponse, category: OrderBookCategory, openingPrice: Double) -> [OrderBookListViewCellData] {
    let emptyCellData = self.emtpyCellData(response: response, category: category)
    let orderBooks = (category == .ask) ? response.data.asks : response.data.bids
    var cellData = orderBooks
      .sorted(by: >)
      .map { orderBook -> OrderBookListViewCellData? in
      guard let orderPrice = Double(orderBook.price),
            let quantity = Double(orderBook.quantity) else { return nil }
      return OrderBookListViewCellData(
        orderBookCategory: category,
        orderPrice: orderPrice,
        orderQuantity: quantity,
        priceChangedRatio: (orderPrice - openingPrice) / orderPrice
      )
    }.compactMap { $0 }
    
    if category == .ask {
      cellData = emptyCellData + cellData
    } else {
      cellData = cellData + emptyCellData
    }
    return cellData
  }

  private func emtpyCellData(response: OrderBookResponse, category: OrderBookCategory) -> [OrderBookListViewCellData] {
    let dataCount = (category == .ask) ? response.data.asks.count : response.data.bids.count
    let emptyCellDataCount = 30 - dataCount
    let emptyCellDatum = OrderBookListViewCellData(
      orderBookCategory: category,
      orderPrice: nil,
      orderQuantity: nil,
      priceChangedRatio: nil
    )
    return Array(
      repeating: emptyCellDatum,
      count: emptyCellDataCount
    )
  }

  func transactionSheetViewCellData(response: TransactionHistoryResponse) -> [TransactionSheetViewCellData] {
    return response.data.map { transactionHistoryData -> TransactionSheetViewCellData? in
      guard let timeText = transactionHistoryData.transactionDate.split(separator: " ").map({ String($0) }).last,
            let orderBookCategory = OrderBookCategory.findOrderBookCategory(with: transactionHistoryData.type),
            let volume = Double(transactionHistoryData.unitsTraded) else {
              return nil
            }
      return TransactionSheetViewCellData(
        orderBookCategory: orderBookCategory,
        transactionPrice: transactionHistoryData.price,
        dateText: timeText,
        volume: volume
      )
    }.compactMap { $0 }
    .reversed()
  }
}
