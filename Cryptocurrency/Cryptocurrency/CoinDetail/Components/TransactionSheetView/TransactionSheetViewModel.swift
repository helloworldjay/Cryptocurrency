//
//  TransactionSheetViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/12.
//

import RxCocoa

protocol TransactionSheetViewModelLogic {
  var transactionSheetViewCellData: PublishRelay<[TransactionSheetViewCellData]> { get }
  var cellData: Driver<[TransactionSheetViewCellData]> { get }
}

final class TransactionSheetViewModel: TransactionSheetViewModelLogic {

  // MARK: Properties

  let transactionSheetViewCellData: PublishRelay<[TransactionSheetViewCellData]>
  let cellData: Driver<[TransactionSheetViewCellData]>

  
  // MARK: Initializer

  init() {
    self.transactionSheetViewCellData = PublishRelay<[TransactionSheetViewCellData]>()

    self.cellData = self.transactionSheetViewCellData
      .asDriver(onErrorJustReturn: [])
  }
}
