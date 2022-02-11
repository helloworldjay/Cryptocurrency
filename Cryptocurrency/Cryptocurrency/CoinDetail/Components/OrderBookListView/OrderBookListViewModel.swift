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
  var askCellData: PublishSubject<[OrderBookListViewCellData]> { get }
  var bidCellData: PublishSubject<[OrderBookListViewCellData]> { get }
}

final class OrderBookListViewModel: OrderBookListViewModelLogic {
  let cellData: Driver<[OrderBookListViewCellData]>
  let askCellData: PublishSubject<[OrderBookListViewCellData]>
  let bidCellData: PublishSubject<[OrderBookListViewCellData]>

  init() {
    self.askCellData = PublishSubject<[OrderBookListViewCellData]>()
    self.bidCellData = PublishSubject<[OrderBookListViewCellData]>()
    
    self.cellData = Observable.zip(
      self.askCellData,
      self.bidCellData
    ).asDriver(onErrorJustReturn: ([], []))
      .map { $0 + $1 }
  }
}
