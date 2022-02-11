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
  func tickerData(response: AllTickerResponse?) -> (data: CoinDetailData, price: Double)?
  func chartData(response: CandleStickResponse?) -> [ChartData]
  func orderBookListViewCellData(response: OrderBookResponse, openingPrice: Double) -> [OrderBookListViewCellData]
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

  func tickerData(response: AllTickerResponse?) -> (data: CoinDetailData, price: Double)? {
    guard let data = response?.data.first,
          let openingPrice = Double(data.value.openingPrice) else {
      return nil
    }
    return (
      CoinDetailData(
        currentPrice: data.value.closingPrice,
        priceChangedRatio: data.value.fluctateRate24H,
        priceDifference: data.value.fluctate24H
      ), openingPrice
    )
  }

  func chartData(response: CandleStickResponse?) -> [ChartData] {
    guard let response = response else {
      return []
    }
    return response.chartData
  }

  func orderBookListViewCellData(response: OrderBookResponse, openingPrice: Double) -> [OrderBookListViewCellData] {
    return response.orderBookListViewCellData(by: openingPrice)
  }
}
