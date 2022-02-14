//
//  TransactionSheetViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/12.
//

import RxCocoa
import RxSwift

protocol TransactionSheetViewModelLogic {
  var transactionSheetViewCellData: PublishSubject<[TransactionSheetViewCellData]> { get }
  var cellData: Driver<[TransactionSheetViewCellData]> { get }
}

final class TransactionSheetViewModel: TransactionSheetViewModelLogic {

  // MARK: Properties

  let transactionSheetViewCellData: PublishSubject<[TransactionSheetViewCellData]>
  let cellData: Driver<[TransactionSheetViewCellData]>


  // MARK: Initializer

  init() {
    self.transactionSheetViewCellData = PublishSubject<[TransactionSheetViewCellData]>()

    self.cellData = self.transactionSheetViewCellData
      .asDriver(onErrorJustReturn: [])
  }
}
