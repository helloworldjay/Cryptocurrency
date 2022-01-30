//
//  CoinListViewModel.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

protocol CoinListViewModelLogic {
  var coinListCellData: PublishSubject<[CoinListViewCellData]> { get set }
  var cellData: Driver<[CoinListViewCellData]> { get set }
  var selectedOrderCurrency: PublishSubject<OrderCurrency> { get set }
}

final class CoinListViewModel: CoinListViewModelLogic {
  var coinListCellData = PublishSubject<[CoinListViewCellData]>()
  var cellData: Driver<[CoinListViewCellData]>
  var selectedOrderCurrency = PublishSubject<OrderCurrency>()

  init() {
    self.cellData = self.coinListCellData
      .asDriver(onErrorJustReturn: [])
  }
}
