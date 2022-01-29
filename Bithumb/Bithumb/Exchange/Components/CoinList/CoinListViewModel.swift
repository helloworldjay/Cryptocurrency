//
//  CoinListViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

struct CoinListViewModel {
  let coinListCellData = PublishSubject<[CoinListViewCellData]>()
  let cellData: Driver<[CoinListViewCellData]>
  let selectedOrderCurrency = PublishSubject<OrderCurrency>()
  
  init() {
    self.cellData = self.coinListCellData
      .asDriver(onErrorJustReturn: [])
  }
}
