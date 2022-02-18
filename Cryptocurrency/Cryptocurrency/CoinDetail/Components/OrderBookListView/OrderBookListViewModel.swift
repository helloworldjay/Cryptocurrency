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
  var initialCellData: PublishRelay<([OrderBookListViewCellData], [OrderBookListViewCellData])> { get }
  var orderBookListViewCellData: PublishRelay<[OrderBookListViewCellData]> { get }
  var cellData: Driver<[OrderBookListViewCellData]> { get }
}

final class OrderBookListViewModel: OrderBookListViewModelLogic {

  // MARK: Properties

  let initialCellData: PublishRelay<([OrderBookListViewCellData], [OrderBookListViewCellData])>
  let orderBookListViewCellData: PublishRelay<[OrderBookListViewCellData]>
  let cellData: Driver<[OrderBookListViewCellData]>
  private let disposeBag = DisposeBag()


  // MARK: Initialzier

  init() {
    self.initialCellData = PublishRelay<([OrderBookListViewCellData], [OrderBookListViewCellData])>()
    self.orderBookListViewCellData = PublishRelay<[OrderBookListViewCellData]>()
    
    self.cellData = self.orderBookListViewCellData
      .asDriver(onErrorJustReturn: [])
  }
}
