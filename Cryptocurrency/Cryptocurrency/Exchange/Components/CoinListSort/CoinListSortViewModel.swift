//
//  CoinListSortViewModel.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/02/11.
//

import RxSwift

typealias CoinListSortCriteria = (isDescending: Bool, coinListSortCriterion: CoinListSortCriterion)

protocol CoinListSortViewModelLogic {
  var coinListSortCriteria: BehaviorSubject<CoinListSortCriteria> { get }
}

final class CoinListSortViewModel: CoinListSortViewModelLogic {

  // MARK: Properties

  let coinListSortCriteria = BehaviorSubject<CoinListSortCriteria>(value: (isDescending: true, coinListSortCriterion: .transactionAmount))
}
