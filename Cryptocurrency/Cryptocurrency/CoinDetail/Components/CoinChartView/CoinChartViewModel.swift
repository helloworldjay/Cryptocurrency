//
//  CoinChartViewModel.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/05.
//

import Foundation

import RxRelay

protocol CoinChartViewModelLogic {
  var chartData: PublishRelay<[ChartData]> { get }
}

final class CoinChartViewModel: CoinChartViewModelLogic {
  let chartData = PublishRelay<[ChartData]>()
}
