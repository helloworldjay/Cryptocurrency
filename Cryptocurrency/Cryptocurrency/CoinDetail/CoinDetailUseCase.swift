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
  func response<T: Decodable>(result: Result<T, APINetworkError>) -> T?
  func tickerData(response: AllTickerResponse?) -> CoinDetailData?
  func openingPrice(for data: CoinDetailData) -> Double
  func chartData(response: CandleStickResponse?) -> [ChartData]
  func bidsCellData(with response: OrderBookResponse, openingPrice: Double) -> [OrderBookListViewCellData]
  func asksCellData(with response: OrderBookResponse, openingPrice: Double) -> [OrderBookListViewCellData]
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

  func response<T: Decodable>(result: Result<T, APINetworkError>) -> T? {
    guard case .success(let value) = result else {
      return nil
    }
    return value
  }

  func tickerData(response: AllTickerResponse?) -> CoinDetailData? {
    guard let data = response?.data.first else {
      return nil
    }
    return (
      CoinDetailData(
        currentPrice: data.value.closingPrice,
        priceChangedRatio: data.value.fluctateRate24H,
        priceDifference: data.value.fluctate24H
      )
    )
  }

  func openingPrice(for data: CoinDetailData) -> Double {
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

  func bidsCellData(with response: OrderBookResponse, openingPrice: Double) -> [OrderBookListViewCellData] {
    let neededEmptyCellDataCount = 30 - response.data.bids.count
    let emptyCellData = self.emptyCellData(orderBookCategory: .bid, count: neededEmptyCellDataCount)
    let cellData = response.data.bids.sorted { lhs, rhs in
      guard let lhsOrderPrice = Double(lhs.price),
            let rhsOrderPrice = Double(rhs.price) else {
              return true
            }
      return lhsOrderPrice > rhsOrderPrice
    }.map { orderBook -> OrderBookListViewCellData? in
      guard let orderPrice = Double(orderBook.price) else { return nil }
      return OrderBookListViewCellData(
        orderBookCategory: .bid,
        orderPrice: orderBook.price,
        orderQuantity: orderBook.quantity,
        priceChangedRatio: (orderPrice - openingPrice) / orderPrice
      )
    }.compactMap { $0 }
    
    return cellData + emptyCellData
  }

  func asksCellData(with response: OrderBookResponse, openingPrice: Double) -> [OrderBookListViewCellData] {
    let neededEmptyCellDataCount = 30 - response.data.asks.count
    let emptyCellData = self.emptyCellData(orderBookCategory: .ask, count: neededEmptyCellDataCount)
    let cellData = response.data.asks.sorted { lhs, rhs in
      guard let lhsOrderPrice = Double(lhs.price),
            let rhsOrderPrice = Double(rhs.price) else {
              return true
            }
      return lhsOrderPrice > rhsOrderPrice
    }.map { orderBook -> OrderBookListViewCellData? in
      guard let orderPrice = Double(orderBook.price) else { return nil }
      return OrderBookListViewCellData(
        orderBookCategory: .ask,
        orderPrice: orderBook.price,
        orderQuantity: orderBook.quantity,
        priceChangedRatio: (orderPrice - openingPrice) / orderPrice
      )
    }.compactMap { $0 }
    
    return emptyCellData + cellData
  }

  private func emptyCellData(orderBookCategory: OrderBookCategory, count: Int) -> [OrderBookListViewCellData] {
    let emptyCellData = OrderBookListViewCellData(
      orderBookCategory: orderBookCategory,
      orderPrice: nil,
      orderQuantity: nil,
      priceChangedRatio: nil
    )
    return Array(
      repeating: emptyCellData,
      count: count
    )
  }
}
