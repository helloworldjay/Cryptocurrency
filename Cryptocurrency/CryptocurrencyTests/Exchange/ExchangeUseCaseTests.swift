//
//  ExchangeUseCaseTests.swift
//  CryptocurrencyTests
//
//  Created by Seungjin Baek on 2022/01/25.
//

import XCTest
@testable import Cryptocurrency

import Nimble

class ExchangeUseCaseTests: XCTestCase {
  
  var sut: ExchangeUseCaseLogic!
  var networkManagerSpy: NetworkManagerLogic!
  
  
  // MARK: Settings
  
  override func setUp() {
    self.networkManagerSpy = NetworkManager()
    self.sut = ExchangeUseCase(network: self.networkManagerSpy)
  }
  
  
  // MARK: Tests
  
  func test_네트워크_결과물이_success일_경우_entity를_반환() {
    //given
    let response = AllTickerResponse(status: "0000", data: [:])
    let result: Result<AllTickerResponse, APINetworkError> = .success(response)
    
    //when
    let entity = self.sut.tickerResponse(result: result)
    
    //then
    expect(entity).notTo(beNil())
    expect(entity!.status).to(equal("0000"))
  }
  
  func test_entity가_nil이_아닐_경우_cell_data를_반환() {
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
    let cellData = self.sut.coinListCellData(response: response)
    
    //then
    expect(cellData).toNot(beEmpty())
    expect(cellData[0].ticker).to(equal("BTC"))
    expect(cellData[0].currentPrice).to(equal("2000"))
    expect(cellData[0].priceChangedRatio).to(equal("1.0"))
  }

  func test_coin_이름으로_정렬_기능_확인() {
    //given
    let testCellData = [
      CoinListViewCellData(
        coinName: "하",
        ticker: "ABC",
        currentPrice: "123",
        priceChangedRatio: "432",
        priceDifference: "842",
        transactionAmount: "424"
      ),
      CoinListViewCellData(
        coinName: "사",
        ticker: "DEF",
        currentPrice: "456",
        priceChangedRatio: "787",
        priceDifference: "931",
        transactionAmount: "852"
      ),
      CoinListViewCellData(
        coinName: "가",
        ticker: "GHI",
        currentPrice: "789",
        priceChangedRatio: "246",
        priceDifference: "263",
        transactionAmount: "682"
      )
    ]
    let expectedAscendingCellData = [
      CoinListViewCellData(
        coinName: "가",
        ticker: "GHI",
        currentPrice: "789",
        priceChangedRatio: "246",
        priceDifference: "263",
        transactionAmount: "682"
      ),
      CoinListViewCellData(
        coinName: "사",
        ticker: "DEF",
        currentPrice: "456",
        priceChangedRatio: "787",
        priceDifference: "931",
        transactionAmount: "852"
      ),
      CoinListViewCellData(
        coinName: "하",
        ticker: "ABC",
        currentPrice: "123",
        priceChangedRatio: "432",
        priceDifference: "842",
        transactionAmount: "424"
      )
    ]

    //when
    let ascendingResult = sut.sortByCoinName(coinListCellData: testCellData, isDescending: false)
    let descendingResult = sut.sortByCoinName(coinListCellData: testCellData, isDescending: true)

    //then
    expect(ascendingResult).to(equal(expectedAscendingCellData))
    expect(descendingResult).toNot(equal(expectedAscendingCellData))
  }

  func test_현재가로_정렬_기능_확인() {
    //given
    let testCellData = [
      CoinListViewCellData(
        coinName: "하",
        ticker: "ABC",
        currentPrice: "123",
        priceChangedRatio: "432",
        priceDifference: "842",
        transactionAmount: "424"
      ),
      CoinListViewCellData(
        coinName: "사",
        ticker: "DEF",
        currentPrice: "456",
        priceChangedRatio: "787",
        priceDifference: "931",
        transactionAmount: "852"
      ),
      CoinListViewCellData(
        coinName: "가",
        ticker: "GHI",
        currentPrice: "789",
        priceChangedRatio: "246",
        priceDifference: "263",
        transactionAmount: "682"
      )
    ]
    let expectedDescendingCellData = [
      CoinListViewCellData(
        coinName: "가",
        ticker: "GHI",
        currentPrice: "789",
        priceChangedRatio: "246",
        priceDifference: "263",
        transactionAmount: "682"
      ),
      CoinListViewCellData(
        coinName: "사",
        ticker: "DEF",
        currentPrice: "456",
        priceChangedRatio: "787",
        priceDifference: "931",
        transactionAmount: "852"
      ),
      CoinListViewCellData(
        coinName: "하",
        ticker: "ABC",
        currentPrice: "123",
        priceChangedRatio: "432",
        priceDifference: "842",
        transactionAmount: "424"
      )
    ]

    //when
    let ascendingResult = sut.sortByCurrentPrice(coinListCellData: testCellData, isDescending: false)
    let descendingResult = sut.sortByCurrentPrice(coinListCellData: testCellData, isDescending: true)

    //then
    expect(ascendingResult).toNot(equal(expectedDescendingCellData))
    expect(descendingResult).to(equal(expectedDescendingCellData))
  }

  func test_가격_변동률로_정렬_기능_확인() {
    //given
    let testCellData = [
      CoinListViewCellData(
        coinName: "하",
        ticker: "ABC",
        currentPrice: "123",
        priceChangedRatio: "432",
        priceDifference: "842",
        transactionAmount: "424"
      ),
      CoinListViewCellData(
        coinName: "사",
        ticker: "DEF",
        currentPrice: "456",
        priceChangedRatio: "787",
        priceDifference: "931",
        transactionAmount: "852"
      ),
      CoinListViewCellData(
        coinName: "가",
        ticker: "GHI",
        currentPrice: "789",
        priceChangedRatio: "246",
        priceDifference: "263",
        transactionAmount: "682"
      )
    ]
    let expectedDescendingCellData = [
      CoinListViewCellData(
        coinName: "사",
        ticker: "DEF",
        currentPrice: "456",
        priceChangedRatio: "787",
        priceDifference: "931",
        transactionAmount: "852"
      ),
      CoinListViewCellData(
        coinName: "하",
        ticker: "ABC",
        currentPrice: "123",
        priceChangedRatio: "432",
        priceDifference: "842",
        transactionAmount: "424"
      ),
      CoinListViewCellData(
        coinName: "가",
        ticker: "GHI",
        currentPrice: "789",
        priceChangedRatio: "246",
        priceDifference: "263",
        transactionAmount: "682"
      )
    ]

    //when
    let ascendingResult = sut.sortByPriceChangedRatio(coinListCellData: testCellData, isDescending: false)
    let descendingResult = sut.sortByPriceChangedRatio(coinListCellData: testCellData, isDescending: true)

    //then
    expect(ascendingResult).toNot(equal(expectedDescendingCellData))
    expect(descendingResult).to(equal(expectedDescendingCellData))
  }

  func test_거래량으로_정렬_기능_확인() {
    //given
    let testCellData = [
      CoinListViewCellData(
        coinName: "하",
        ticker: "ABC",
        currentPrice: "123",
        priceChangedRatio: "432",
        priceDifference: "842",
        transactionAmount: "424"
      ),
      CoinListViewCellData(
        coinName: "사",
        ticker: "DEF",
        currentPrice: "456",
        priceChangedRatio: "787",
        priceDifference: "931",
        transactionAmount: "852"
      ),
      CoinListViewCellData(
        coinName: "가",
        ticker: "GHI",
        currentPrice: "789",
        priceChangedRatio: "246",
        priceDifference: "263",
        transactionAmount: "682"
      )
    ]
    let expectedDescendingCellData = [
      CoinListViewCellData(
        coinName: "사",
        ticker: "DEF",
        currentPrice: "456",
        priceChangedRatio: "787",
        priceDifference: "931",
        transactionAmount: "852"
      ),
      CoinListViewCellData(
        coinName: "가",
        ticker: "GHI",
        currentPrice: "789",
        priceChangedRatio: "246",
        priceDifference: "263",
        transactionAmount: "682"
      ),
      CoinListViewCellData(
        coinName: "하",
        ticker: "ABC",
        currentPrice: "123",
        priceChangedRatio: "432",
        priceDifference: "842",
        transactionAmount: "424"
      )
    ]

    //when
    let ascendingResult = sut.sortByTransactionAmount(coinListCellData: testCellData, isDescending: false)
    let descendingResult = sut.sortByTransactionAmount(coinListCellData: testCellData, isDescending: true)

    //then
    expect(ascendingResult).toNot(equal(expectedDescendingCellData))
    expect(descendingResult).to(equal(expectedDescendingCellData))
  }
}
