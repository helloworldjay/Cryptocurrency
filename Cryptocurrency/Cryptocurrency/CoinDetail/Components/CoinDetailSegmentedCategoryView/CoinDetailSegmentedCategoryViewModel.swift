//
//  CoinDetailSegmentedCategoryViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/08.
//

import Foundation

import RxRelay

protocol CoinDetailSegmentedCategoryViewModelLogic {
  var category: BehaviorRelay<CoinDetailCategory> { get }
}

final class CoinDetailSegmentedCategoryViewModel: CoinDetailSegmentedCategoryViewModelLogic {
  let category = BehaviorRelay<CoinDetailCategory>(value: .orderBook)
}
