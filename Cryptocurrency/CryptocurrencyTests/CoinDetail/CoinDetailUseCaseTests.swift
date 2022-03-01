//
//  CoinDetailUseCaseTests.swift
//  CryptocurrencyTests
//
//  Created by 이영우 on 2022/02/05.
//

import XCTest
@testable import Cryptocurrency

import Nimble

final class CoinDetailUseCaseTests: XCTestCase {
  
  var sut: CoinDetailUseCaseLogic!
  var networkManagerSpy: NetworkManagerLogic!
  
  
  // MARK: Settings
  
  override func setUp() {
    self.networkManagerSpy = NetworkManager()
    self.sut = CoinDetailUseCase(network: self.networkManagerSpy)
  }
  
  
  // MARK: Tests
  
  func test_AllTickerResponse_네트워크_결과물이_success일_경우_entity를_반환() {
    //given
    let response = AllTickerResponse(status: "0000", data: [:])
    let result: Result<AllTickerResponse, APINetworkError> = .success(response)
    
    //when
    let entity = self.sut.response(result: result)
    
    //then
    expect(entity).notTo(beNil())
    expect(entity!.status).to(equal("0000"))
  }
  
  func test_CandleStickResponse_네트워크_결과물이_success일_경우_entity를_반환() {
    //given
    let response = CandleStickResponse(status: "0000", data: [[]])
    let result: Result<CandleStickResponse, APINetworkError> = .success(response)
    
    //when
    let entity = self.sut.response(result: result)
    
    //then
    expect(entity).notTo(beNil())
    expect(entity!.status).to(equal("0000"))
  }

  func test_OrderBookResponse_네트워크_결과물이_success일_경우_entity를_반환() {
    //given
    let orderBookData = OrderBookData(
      timestamp: "1644491778626",
      orderCurrency: "KRW",
      paymentCurrency: "BTC",
      bids: [OrderBook(quantity: "53910000", price: "0.3699")],
      asks: [OrderBook(quantity: "53910000", price: "0.3699")]
    )
    let response = OrderBookResponse(status: "0000", data: orderBookData)
    let result: Result<OrderBookResponse, APINetworkError> = .success(response)
    
    //when
    let entity = self.sut.response(result: result)
    
    //then
    expect(entity).notTo(beNil())
    expect(entity!.status).to(equal("0000"))
  }
  
  func test_TransactionHistoryResponse_네트워크_결과물이_success일_경우_entity를_반환() {
    //given
    let transactionData = TransactionHistoryData(
      transactionDate: "2022-02-13 20:47:52",
      type: "bid",
      unitsTraded: "339521.5664",
      price: "0.0027",
      total: "916"
    )
    let response = TransactionHistoryResponse(status: "0000", data: [transactionData])
    let result: Result<TransactionHistoryResponse, APINetworkError> = .success(response)
    
    //when
    let entity = self.sut.response(result: result)
    
    //then
    expect(entity).notTo(beNil())
    expect(entity!.status).to(equal("0000"))
  }

  func test_AllTickerResponse가_nil일_경우_ticker_data를_nil로_반환() {
    //given
    let response: AllTickerResponse? = nil
    
    //when
    let tickerData = self.sut.tickerData(response: response)
    
    //then
    expect(tickerData).to(beNil())
  }
  
  func test_AllTickerResponse가_nil이_아닐_경우_ticker_data를_반환() {
    //given
    let response: AllTickerResponse = AllTickerResponse(
      status: "0000",
      data: [
        "BTC": TickerData(
          openingPrice: "1000",
          closingPrice: "2000",
          minPrice: "3000",
          maxPrice: "4000",
          tradedUnit: "5000",
          accTradeValue: "6000",
          previousClosingPrice: "7000",
          tradedUnit24H: "8000",
          accTradeValue24H: "9000",
          fluctate24H: "10000",
          fluctateRate24H: "1.0",
          date: nil
        )
      ]
    )
    
    //when
    let tickerData = self.sut.tickerData(response: response)
    
    //then
    expect(tickerData).toNot(beNil())
    expect(tickerData!.currentPrice).to(equal("2000"))
    expect(tickerData!.priceDifference).to(equal("10000"))
    expect(tickerData!.priceChangedRatio).to(equal("1.0"))
  }
  
  func test_CandleStickResponse가_nil이_아닐_경우_chart_data를_반환() {
    //given
    let response: CandleStickResponse = CandleStickResponse(
      status: "0000",
      data: [
        [
          .timeInterval(1388070000000),
          .information("737000"),
          .information("755000"),
          .information("755000"),
          .information("737000"),
          .information("3.78")
        ]
      ]
    )
    
    //when
    let chartData = self.sut.chartData(response: response)
    
    //then
    expect(chartData).toNot(beEmpty())
    expect(chartData[0].openPrice).to(equal(737000))
    expect(chartData[0].closePrice).to(equal(755000))
    expect(chartData[0].highPrice).to(equal(755000))
    expect(chartData[0].lowPrice).to(equal(737000))
    expect(chartData[0].exchangeVolume).to(equal(3.78))
  }
  
  func test_OrderBookResponse가_nil이_아닐_경우_orderBook_listview_cell_data를_반환() {
    //given
    let response = OrderBookResponse(
      status: "0000",
      data: OrderBookData(
        timestamp: "1644491778626",
        orderCurrency: "KRW",
        paymentCurrency: "BTC",
        bids: [OrderBook(quantity: "53910000", price: "0.3699")],
        asks: []
      )
    )
    let openingPrice: Double = 123.9
    
    //when
    let orderBookListViewCellData = self.sut.orderBookListViewCellData(with: response,
                                                                       category: .bid,
                                                                       openingPrice: openingPrice)
    
    //then
    expect(orderBookListViewCellData).toNot(beEmpty())
    expect(orderBookListViewCellData[0].orderBookCategory).to(equal(OrderBookCategory.bid))
    expect(orderBookListViewCellData[0].orderPrice).to(equal(0.3699))
    expect(orderBookListViewCellData[0].orderQuantity).to(equal(53910000))
  }

  func test_SocketTickerResponse에_해당하는_data가_들어올_경우_Decoding성공_후_entity를_반환() {
    //given
    let socketText = """
    {
      "type" : "ticker",
      "content" : {
        "symbol" : "BTC_KRW",
        "tickType" : "24H",
        "date" : "20200129",
        "time" : "121844",
        "openPrice" : "2302",
        "closePrice" : "2317",
        "lowPrice" : "2272",
        "highPrice" : "2344",
        "value" : "2831915078.07065789",
        "volume" : "1222314.51355788",
        "sellVolume" : "760129.34079004",
        "buyVolume" : "462185.17276784",
        "prevClosePrice" : "2326",
        "chgRate" : "0.65",
        "chgAmt" : "15",
        "volumePower" : "60.80"
      }
    }
    """
    let data = socketText.data(using: .utf8)!
    let expectedResponse = SocketTickerResponse(
      type: "ticker",
      content: SocketTickerData(
        tickType: "24H",
        date: "20200129",
        time: "121844",
        openPrice: "2302",
        closePrice: "2317",
        lowPrice: "2272",
        highPrice: "2344",
        value: "2831915078.07065789",
        volume: "1222314.51355788",
        sellVolume: "760129.34079004",
        buyVolume: "462185.17276784",
        previousClosePrice: "2326",
        changeRate: "0.65",
        changeAmount: "15",
        volumePower: "60.80",
        symbol: "BTC_KRW"
      )
    )

    //when
    let socketTickerResponse = self.sut.decodedSocketResponse(as: SocketTickerResponse.self, with: data)

    //then
    expect(socketTickerResponse).toNot(beNil())
    expect(socketTickerResponse!.content.closePrice).to(equal(expectedResponse.content.closePrice))
    expect(socketTickerResponse!.content.openPrice).to(equal(expectedResponse.content.openPrice))
    expect(socketTickerResponse!.content.changeRate).to(equal(expectedResponse.content.changeRate))
  }

  func text_SocketOrderBookResponse에_해당하는_data가_들어올_경우_Decoding성공_후_entity를_반환() {
    //given
    let socketText = """
    {
       "type": "orderbookdepth",
       "content": {
           "list": [
               {
                   "symbol": "BTC_KRW",
                   "orderType": "ask",
                   "price": "53365000",
                   "quantity": "0",
                   "total": "0"
               }
           ],
           "datetime": "1644918923346784"
       }
    }
    """
    let data = socketText.data(using: .utf8)!
    let expectedResponse = SocketOrderBookResponse(
      type: "orderbookdepth",
      content: SocketOrderBookData(
        list: [
          SocketOrderBook(
            symbol: "BTC_KRW",
            price: "53365000",
            quantity: "0",
            total: "0",
            orderType: .ask
          )
        ],
        datetime: "1644918923346784"
      )
    )

    //when
    let socketOrderBookResponse = self.sut.decodedSocketResponse(as: SocketOrderBookResponse.self, with: data)

    //then
    expect(socketOrderBookResponse).toNot(beNil())
    expect(socketOrderBookResponse!.content.list.first).toNot(beNil())
    expect(socketOrderBookResponse!.content.list.first!.symbol).to(equal(expectedResponse.content.list.first!.symbol))
    expect(socketOrderBookResponse!.content.list.first!.price).to(equal(expectedResponse.content.list.first!.price))
    expect(socketOrderBookResponse!.content.list.first!.quantity).to(equal(expectedResponse.content.list.first!.quantity))
  }

  func test_SocketTransactionResponse에_해당하는_data가_들어올_경우_Decoding성공_후_entity를_반환() {
    //given
    let socketText = """
    {
       "type": "transaction",
       "content": {
           "list": [
               {
                   "buySellGb": "2",
                   "contPrice": "51224000",
                   "contQty": "0.106",
                   "contAmt": "5429744.000",
                   "contDtm": "2022-02-14 16:13:40.122852",
                   "updn": "dn",
                   "symbol": "BTC_KRW"
               }
           ]
       }
    }
    """
    let data = socketText.data(using: .utf8)!
    let expectedResponse = SocketTransactionResponse(
      type: "transaction",
      content: SocketTransactionHistoryData(
        list: [
          SocketTransactionHistory(
            contractType: "2",
            contractPrice: "51224000",
            contractQuantity: "0.106",
            contractAmount: "5429744.000",
            contractDatemessage: "2022-02-14 16:13:40.122852",
            upDown: "dn",
            symbol: "BTC_KRW"
          )
        ]
      )
    )

    //when
    let socketTransactionResponse = self.sut.decodedSocketResponse(as: SocketTransactionResponse.self, with: data)

    //then
    expect(socketTransactionResponse).toNot(beNil())
    expect(socketTransactionResponse!.content.list.first).toNot(beNil())
    expect(socketTransactionResponse!.content.list.first!.contractType).to(equal(expectedResponse.content.list.first!.contractType))
    expect(socketTransactionResponse!.content.list.first!.contractPrice).to(equal(expectedResponse.content.list.first!.contractPrice))
    expect(socketTransactionResponse!.content.list.first!.contractAmount).to(equal(expectedResponse.content.list.first!.contractAmount))
  }

  func test_SocketTickerResponse에_해당되는_tickerData를_반환() {
    //given
    let socketTickerResponse = SocketTickerResponse(
      type: "ticker",
      content: SocketTickerData(
        tickType: "24H", date: "20200129", time: "121844",
        openPrice: "2302", closePrice: "2317", lowPrice: "2272",
        highPrice: "2344", value: "2831915078.07065789",
        volume: "1222314.51355788", sellVolume: "760129.34079004",
        buyVolume: "462185.17276784", previousClosePrice: "2326",
        changeRate: "0.65", changeAmount: "15", volumePower: "60.80",
        symbol: "BTC_KRW"
      )
    )
    let expectedCoinPriceData = CoinPriceData(
      currentPrice: "2317",
      priceChangedRatio: "0.65",
      priceDifference: "15"
    )

    //when
    let coinPriceData = self.sut.coinPriceData(with: socketTickerResponse)

    //then
    expect(coinPriceData.currentPrice).to(equal(expectedCoinPriceData.currentPrice))
    expect(coinPriceData.priceDifference).to(equal(expectedCoinPriceData.priceDifference))
    expect(coinPriceData.priceChangedRatio).to(equal(expectedCoinPriceData.priceChangedRatio))
  }

  func test_SocketOrderBookResponse에_해당되는_배열을_반환() {
    //given
    let socketOrderBookResponse = SocketOrderBookResponse(
      type: "orderbookdepth",
      content: SocketOrderBookData(
        list: [
          SocketOrderBook(
            symbol: "BTC_KRW",
            price: "53365000",
            quantity: "11.0",
            total: "10.0",
            orderType: .ask
          )
        ],
        datetime: "1644918923346784"
      )
    )
    let expectedCellData = [
      OrderBookListViewCellData(
        orderBookCategory: .ask,
        orderPrice: 53365000,
        orderQuantity: 11.0,
        priceChangedRatio: 0
      )
    ]

    //when
    let orderBookListViewCellData = self.sut.orderBookListViewCellData(with: socketOrderBookResponse,
                                                                       category: .ask,
                                                                       openingPrice: 53365000)

    //then
    expect(orderBookListViewCellData).toNot(beEmpty())
    expect(orderBookListViewCellData.first!.orderBookCategory).to(equal(expectedCellData.first!.orderBookCategory))
    expect(orderBookListViewCellData.first!.orderPrice).to(equal(expectedCellData.first!.orderPrice))
    expect(orderBookListViewCellData.first!.orderQuantity).to(equal(expectedCellData.first!.orderQuantity))
    expect(orderBookListViewCellData.first!.priceChangedRatio).to(equal(expectedCellData.first!.priceChangedRatio))
  }

  func test_SocketTransactionResponse에_해당되는_배열을_반환() {
    //given
    let socketTransactionResponse = SocketTransactionResponse(
      type: "transaction",
      content: SocketTransactionHistoryData(
        list: [
          SocketTransactionHistory(
            contractType: "2",
            contractPrice: "51224000",
            contractQuantity: "0.106",
            contractAmount: "5429744.0",
            contractDatemessage: "2022-02-14 16:13:40.122852",
            upDown: "dn",
            symbol: "BTC_KRW"
          )
        ]
      )
    )
    let expectedCellData = [
      TransactionSheetViewCellData(
        orderBookCategory: .bid,
        transactionPrice: "51224000",
        dateText: "2022-02-14 16:13:40.122852",
        volume: 0.106
      )
    ]

    //when
    let transactionSheetViewCellData = self.sut.transactionSheetViewCellData(with: socketTransactionResponse)

    //then
    expect(transactionSheetViewCellData).toNot(beEmpty())
    expect(transactionSheetViewCellData.first!.orderBookCategory).to(equal(expectedCellData.first!.orderBookCategory))
    expect(transactionSheetViewCellData.first!.transactionPrice).to(equal(expectedCellData.first!.transactionPrice))
    expect(transactionSheetViewCellData.first!.dateText).to(equal(expectedCellData.first!.dateText))
    expect(transactionSheetViewCellData.first!.volume).to(equal(expectedCellData.first!.volume))
  }

  func test_OrderBookListViewCellData를_합칠경우_Quantity가_0혹은_nil제외한_배열_반환() {
    //given
    let preOrderBookListViewCellData = [
      OrderBookListViewCellData(
        orderBookCategory: .ask, orderPrice: 222000,
        orderQuantity: 1, priceChangedRatio: 0
      ),
      OrderBookListViewCellData(
        orderBookCategory: .ask, orderPrice: 111000,
        orderQuantity: 1, priceChangedRatio: 0
      ),
    ]
    let postOrderBookListViewCellData = [
      OrderBookListViewCellData(
        orderBookCategory: .ask, orderPrice: 333000,
        orderQuantity: nil, priceChangedRatio: 0
      ),
      OrderBookListViewCellData(
        orderBookCategory: .ask, orderPrice: 333000,
        orderQuantity: 0, priceChangedRatio: 0
      ),
      OrderBookListViewCellData(
        orderBookCategory: .ask, orderPrice: 333000,
        orderQuantity: 1, priceChangedRatio: 0
      )
    ]
    let expectedCellData = [
      OrderBookListViewCellData(
        orderBookCategory: .ask, orderPrice: 222000,
        orderQuantity: 1, priceChangedRatio: 0
      ),
      OrderBookListViewCellData(
        orderBookCategory: .ask, orderPrice: 111000,
        orderQuantity: 1, priceChangedRatio: 0
      ),
      OrderBookListViewCellData(
        orderBookCategory: .ask, orderPrice: 333000,
        orderQuantity: 1, priceChangedRatio: 0
      )
    ]

    //when
    let cellData = self.sut.mergeOrderBookListViewCellData(preCellData: preOrderBookListViewCellData,
                                                           postCellData: postOrderBookListViewCellData)

    //then
    expect(cellData).to(equal(expectedCellData))
  }

  func test_OrderBookListViewCellData가_30개보다_적을경우_emptyCellData를_채워서_반환() {
    //given
    let orderBookListViewCellData = [
      OrderBookListViewCellData(
        orderBookCategory: .ask,
        orderPrice: 3000,
        orderQuantity: 12,
        priceChangedRatio: 0.56
      )
    ]
    let emptyCellData = OrderBookListViewCellData(orderBookCategory: .ask,
                                                  orderPrice: nil,
                                                  orderQuantity: nil,
                                                  priceChangedRatio: nil)
    let expectedCellData = Array(repeating: emptyCellData, count: 29) + [
      OrderBookListViewCellData(
        orderBookCategory: .ask,
        orderPrice: 3000,
        orderQuantity: 12,
        priceChangedRatio: 0.56
      )
    ]

    //when
    let cellData = self.sut.filledCellData(orderBookListViewCellData: orderBookListViewCellData,
                                    category: .ask)

    //then
    expect(cellData).to(equal(expectedCellData))
  }

  func test_OrderBookListViewCellData가_30개보다_많을경우_emptyCellData를_채워서_반환() {
    //given
    let orderBookListViewCellDatum = OrderBookListViewCellData(
      orderBookCategory: .ask,
      orderPrice: 1000,
      orderQuantity: 1,
      priceChangedRatio: 0.3
    )
    let orderBookListViewCellData = Array(
      repeating: orderBookListViewCellDatum,
      count: 35
    )
    let expectedCount = 30

    //when
    let cellData = self.sut.filledCellData(orderBookListViewCellData: orderBookListViewCellData,
                                    category: .ask)

    //then
    expect(cellData.count).to(equal(expectedCount))
  }
}
