//
//  CoinChartViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation

import RxRelay

protocol CoinChartViewModelLogic {
  var chartData: PublishRelay<[ChartData]> { get }
}

final class CoinChartViewModel: CoinChartViewModelLogic {

  // MARK: Properties

  let chartData = PublishRelay<[ChartData]>()
}
