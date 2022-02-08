//
//  PriceViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/08.
//

import RxRelay

protocol PriceViewModelLogic {
  var coinDetailData: PublishRelay<CoinDetailData?> { get }
}

final class PriceViewModel: PriceViewModelLogic {
  let coinDetailData = PublishRelay<CoinDetailData?>()
}
