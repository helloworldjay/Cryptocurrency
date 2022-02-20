//
//  FavoriteGridViewModel.swift
//  Cryptocurrency
//
//  Created by 김민성 on 2022/02/17.
//

import RxCocoa
import RxSwift

protocol FavoriteGridViewModelLogic {
  var cellData: Driver<[FavoriteGridViewCellData]> { get }
  var favoriteGridCellData: PublishSubject<[FavoriteGridViewCellData]> { get }
  var selectedCellData: PublishSubject<(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency)> { get }
}

final class FavoriteGridViewModel: FavoriteGridViewModelLogic {

  // MARK: Properties

  var cellData: Driver<[FavoriteGridViewCellData]>
  let favoriteGridCellData = PublishSubject<[FavoriteGridViewCellData]>()
  let selectedCellData = PublishSubject<(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency)>()

  // MARK: Initializers

  init() {
    self.cellData = self.favoriteGridCellData
      .asDriver(onErrorJustReturn: [])
  }
}
