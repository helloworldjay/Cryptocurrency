//
//  PriceViewModel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/08.
//

import RxRelay

protocol CurrentPriceStatusViewModelLogic {
  var coinDetailData: PublishRelay<CoinDetailData> { get }
}

final class CurrentPriceStatusViewModel: CurrentPriceStatusViewModelLogic {
  let coinDetailData = PublishRelay<CoinDetailData>()
}
