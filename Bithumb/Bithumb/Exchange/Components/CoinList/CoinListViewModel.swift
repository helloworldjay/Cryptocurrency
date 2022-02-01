//
//  CoinListViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

protocol CoinListViewModelLogic {
  var coinListCellData: PublishSubject<[CoinListViewCellData]> { get }
  var cellData: Driver<[CoinListViewCellData]> { get }
  var selectedOrderCurrency: PublishSubject<OrderCurrency> { get }
}

final class CoinListViewModel: CoinListViewModelLogic {
  let coinListCellData = PublishSubject<[CoinListViewCellData]>()
  let cellData: Driver<[CoinListViewCellData]>
  let selectedOrderCurrency = PublishSubject<OrderCurrency>()

  init() {
    self.cellData = self.coinListCellData
      .asDriver(onErrorJustReturn: [])
  }
}
