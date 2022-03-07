//
//  CoinDetailUseCase.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation

import RxSwift

protocol CoinDetailUseCaseLogic {
  func fetchTicker(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<AllTickerResponse, APINetworkError>>
  func fetchCandleStick(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency, timeUnit: TimeUnit) -> Single<Result<CandleStickResponse, APINetworkError>>
  func fetchOrderBook(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<OrderBookResponse, APINetworkError>>
  func fetchTransactionHistory(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) -> Single<Result<TransactionHistoryResponse, APINetworkError>>
  func response<T: Decodable>(result: Result<T, APINetworkError>) -> T?
  func tickerData(response: AllTickerResponse?) -> CoinPriceData?
  func openingPrice(of data: CoinPriceData) -> Double
  func chartData(response: CandleStickResponse) -> [ChartData]
  func orderBookListViewCellData(with response: OrderBookResponse, category: OrderBookCategory, openingPrice: Double) -> [OrderBookListViewCellData]
  func transactionSheetViewCellData(response: TransactionHistoryResponse) -> [TransactionSheetViewCellData]
  func decodedSocketResponse<T: Decodable>(as type: T.Type, with data: Data) -> T?
  func orderBookListViewCellData(with response: SocketOrderBookResponse, category: OrderBookCategory, openingPrice: Double) -> [OrderBookListViewCellData]
  func coinPriceData(with response: SocketTickerResponse) -> CoinPriceData
  func transactionSheetViewCellData(with response: SocketTransactionResponse) -> [TransactionSheetViewCellData]
  func mergeOrderBookListViewCellData(preCellData: [OrderBookListViewCellData], postCellData: [OrderBookListViewCellData]) -> [OrderBookListViewCellData]
  func filledCellData(orderBookListViewCellData: [OrderBookListViewCellData], category: OrderBookCategory) -> [OrderBookListViewCellData]
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

  func chartData(response: CandleStickResponse) -> [ChartData] {
    var timeInterval = 0.0
    var openPrice = 0.0
    var closePrice = 0.0
    var highPrice = 0.0
    var lowPrice = 0.0
    var exchangeVolume = 0.0

    return response.data.map { candleStickData -> ChartData? in
      for index in 0..<candleStickData.count {
        guard let candleStickDatum = candleStickData[safe: index] else { return nil }

        switch candleStickDatum {
        case .timeInterval(let number):
          timeInterval = number
        case .information(let number):
          guard let number = Double(number) else { return nil }

          if index == 1 {
            openPrice = number
          } else if index == 2 {
            closePrice = number
          } else if index == 3 {
            highPrice = number
          } else if index == 4 {
            lowPrice = number
          } else if index == 5 {
            exchangeVolume = number
          }
        }
      }
      return ChartData(timeInterval: timeInterval,
                       openPrice: openPrice,
                       closePrice: closePrice,
                       highPrice: highPrice,
                       lowPrice: lowPrice,
                       exchangeVolume: exchangeVolume)
    }.compactMap { $0 }
  }

  func orderBookListViewCellData(with response: OrderBookResponse, category: OrderBookCategory, openingPrice: Double) -> [OrderBookListViewCellData] {
    let dataCount = (category == .ask) ? response.data.asks.count : response.data.bids.count
    let emptyCellDataCount = 30 - dataCount
    let emptyCellData = self.emptyCellData(count: emptyCellDataCount, category: category)
    let orderBooks = (category == .ask) ? response.data.asks : response.data.bids
    var cellData = orderBooks
      .sorted(by: self.orderBookPriceCriterion)
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

  private func orderBookPriceCriterion(lhs: OrderBook, rhs: OrderBook) -> Bool {
    guard let lhsPrice = Double(lhs.price),
          let rhsPrice = Double(rhs.price) else {
            return false
          }
    return lhsPrice < rhsPrice
  }

  func orderBookListViewCellData(with response: SocketOrderBookResponse, category: OrderBookCategory, openingPrice: Double) -> [OrderBookListViewCellData] {
    let socketOrderBooks = response.content.list.filter { $0.orderType == category }
    return socketOrderBooks.map { socketOrderBook -> OrderBookListViewCellData? in
      guard let orderPrice = Double(socketOrderBook.price),
            let orderQuantity = Double(socketOrderBook.quantity) else { return nil }
      return OrderBookListViewCellData(
        orderBookCategory: category,
        orderPrice: orderPrice,
        orderQuantity: orderQuantity,
        priceChangedRatio: (orderPrice - openingPrice) / orderPrice
      )
    }.compactMap { $0 }
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

  func decodedSocketResponse<T: Decodable>(as type: T.Type, with data: Data) -> T? {
    return try? JSONDecoder().decode(type, from: data)
  }

  func orderBookListViewCellData(with response: SocketOrderBookResponse, openingPrice: Double) -> [OrderBookListViewCellData] {
    return response.content.list.map { socketOrderBook -> OrderBookListViewCellData? in
      guard let orderPrice = Double(socketOrderBook.price),
            let quantity = Double(socketOrderBook.quantity) else { return nil }
      return OrderBookListViewCellData(
        orderBookCategory: socketOrderBook.orderType,
        orderPrice: orderPrice,
        orderQuantity: quantity,
        priceChangedRatio: (orderPrice - openingPrice) / orderPrice
      )
    }.compactMap { $0 }
  }

  func coinPriceData(with response: SocketTickerResponse) -> CoinPriceData {
    return CoinPriceData(
      currentPrice: response.content.closePrice,
      priceChangedRatio: response.content.changeRate,
      priceDifference: response.content.changeAmount
    )
  }

  func transactionSheetViewCellData(with response: SocketTransactionResponse) -> [TransactionSheetViewCellData] {
    return response.content.list.map { socketTransactionHistory -> TransactionSheetViewCellData? in
      let category = (socketTransactionHistory.upDown == "up") ? OrderBookCategory.ask : OrderBookCategory.bid
      guard let volume = Double(socketTransactionHistory.contractQuantity) else {
        return nil
      }

      return TransactionSheetViewCellData(
        orderBookCategory: category,
        transactionPrice: socketTransactionHistory.contractPrice,
        dateText: socketTransactionHistory.contractDateMessage,
        volume: volume
      )
    }.compactMap { $0 }
  }

  func mergeOrderBookListViewCellData(preCellData: [OrderBookListViewCellData], postCellData: [OrderBookListViewCellData]) -> [OrderBookListViewCellData] {
    var mergedCellData = preCellData
    postCellData.forEach {
      if let index = mergedCellData.binarySearchForDescending(item: $0) {
        mergedCellData[index] = $0
      } else {
        mergedCellData.append($0)
      }
    }
    return self.exceptedEmptyCellData(from: mergedCellData)
  }

  private func exceptedEmptyCellData(from cellData: [OrderBookListViewCellData]) -> [OrderBookListViewCellData] {
    return cellData
      .filter { $0.orderQuantity != 0 }
      .filter { $0.orderQuantity != nil }
  }

  func filledCellData(orderBookListViewCellData: [OrderBookListViewCellData], category: OrderBookCategory) -> [OrderBookListViewCellData] {
    var cellData = orderBookListViewCellData
    cellData.sortByOrderPrice()
    if cellData.count > 30 {
      cellData = self.removeUnnecessaryCellData(orderBookListViewCellData: cellData, category: category)
    } else if cellData.count < 30 {
      cellData = self.addEmptyCellData(orderBookListViewCellData: cellData, category: category)
    }
    return cellData
  }

  private func removeUnnecessaryCellData(orderBookListViewCellData: [OrderBookListViewCellData], category: OrderBookCategory) -> [OrderBookListViewCellData] {
    var cellData = orderBookListViewCellData
    let exceedCount = cellData.count - 30
    var rangeToRemove: Range<Int>

    if exceedCount <= 0 {
      return cellData
    }

    if category == .ask {
      rangeToRemove = 0..<exceedCount
    } else {
      rangeToRemove = 30..<(30 + exceedCount)
    }
    guard cellData[safe: rangeToRemove] != nil else { return orderBookListViewCellData }
    cellData.removeSubrange(rangeToRemove)
    return cellData
  }

  private func addEmptyCellData(orderBookListViewCellData: [OrderBookListViewCellData], category: OrderBookCategory) -> [OrderBookListViewCellData] {
    let cellData = orderBookListViewCellData
    let emptyCount = 30 - cellData.count
    let emptyCellData = self.emptyCellData(count: emptyCount, category: category)

    if emptyCount <= 0 {
      return cellData
    }

    if category == .ask {
      return emptyCellData + cellData
    } else {
      return cellData + emptyCellData
    }
  }

  private func emptyCellData(count: Int, category: OrderBookCategory) -> [OrderBookListViewCellData] {
    let emptyCellDatum = OrderBookListViewCellData(
      orderBookCategory: category,
      orderPrice: nil,
      orderQuantity: nil,
      priceChangedRatio: nil
    )
    return Array(repeating: emptyCellDatum, count: count)
  }
}
