//
//  OrderBookListViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/09.
//

import RxRelay
import RxSwift
import RxCocoa

protocol OrderBookListViewModelLogic {
  var cellData: Driver<[OrderBookListViewCellData]> { get }
  var orderBookListViewCellData: PublishSubject<[OrderBookListViewCellData]> { get }
}

final class OrderBookListViewModel: OrderBookListViewModelLogic {
  let cellData: Driver<[OrderBookListViewCellData]>
  let orderBookListViewCellData: PublishSubject<[OrderBookListViewCellData]>

  init() {
    self.orderBookListViewCellData = PublishSubject<[OrderBookListViewCellData]>()
    
    self.cellData = self.orderBookListViewCellData
      .asDriver(onErrorJustReturn: [])
  }
}
