//
//  PriceViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/08.
//

import RxRelay

protocol CurrentPriceStatusViewModelLogic {
  var coinPriceData: PublishRelay<CoinPriceData> { get }
}

final class CurrentPriceStatusViewModel: CurrentPriceStatusViewModelLogic {

  // MARK: Properties

  let coinPriceData = PublishRelay<CoinPriceData>()
}
