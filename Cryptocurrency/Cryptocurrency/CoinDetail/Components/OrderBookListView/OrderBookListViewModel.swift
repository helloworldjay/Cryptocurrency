//
//  OrderBookListViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/09.
//

import RxRelay

protocol OrderBookListViewModelLogic {
  var cellData: PublishRelay<[OrderBookListViewCellData]> { get }
  var openingPrice: PublishRelay<Double> { get }
}

final class OrderBookListViewModel: OrderBookListViewModelLogic {
  let cellData = PublishRelay<[OrderBookListViewCellData]>()
  let openingPrice = PublishRelay<Double>()
}
