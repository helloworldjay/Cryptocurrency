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
  func openingPrice(of data: CoinDetailData) -> Double
  func chartData(response: CandleStickResponse?) -> [ChartData]
  func orderBookListViewCellData(with response: OrderBookResponse, category: OrderBookCategory, openingPrice: Double) -> [OrderBookListViewCellData]
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

  func openingPrice(of data: CoinDetailData) -> Double {
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
      guard let orderPrice = Double(orderBook.price) else { return nil }
      return OrderBookListViewCellData(
        orderBookCategory: category,
        orderPrice: orderBook.price,
        orderQuantity: orderBook.quantity,
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
}
