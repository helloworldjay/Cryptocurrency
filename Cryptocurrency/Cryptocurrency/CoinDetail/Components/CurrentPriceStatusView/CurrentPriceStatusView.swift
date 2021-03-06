//
//  CurrentPriceStatusView.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/08.
//

import UIKit

import RxSwift
import SnapKit

final class CurrentPriceStatusView: UIView {
  
  // MARK: Properties
  
  private let priceChangedRatioLabel = UILabel()
  private let priceDifferenceLabel = UILabel()
  private let currentPriceLabel = UILabel()
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializer
  
  init() {
    super.init(frame: .zero)
    
    self.layout()
    self.attribute()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    [self.priceChangedRatioLabel,
     self.priceDifferenceLabel,
     self.currentPriceLabel].forEach {
      self.addSubview($0)
    }
    
    self.currentPriceLabel.snp.makeConstraints {
      $0.leading.top.trailing.equalTo(self.safeAreaLayoutGuide)
    }
    
    self.priceDifferenceLabel.snp.makeConstraints {
      $0.leading.bottom.equalToSuperview()
      $0.top.equalTo(self.currentPriceLabel.snp.bottom).offset(10)
    }
    
    self.priceChangedRatioLabel.snp.makeConstraints {
      $0.leading.equalTo(self.priceDifferenceLabel.snp.trailing).offset(10)
      $0.trailing.equalTo(self.snp.trailing)
      $0.centerY.equalTo(self.priceDifferenceLabel.snp.centerY)
    }
  }

  private func attribute() {
    self.currentPriceLabel.font = .systemFont(ofSize: 30)
    self.priceChangedRatioLabel.textAlignment = .left

    self.initializeLabelText()
  }

  private func initializeLabelText() {
    self.currentPriceLabel.text = "0.00"
    self.priceDifferenceLabel.text = "0.00"
    self.priceChangedRatioLabel.text = "0.00"
  }
  
  
  // MARK: Binding
  
  func bind(viewModel: CurrentPriceStatusViewModel) {
    viewModel.coinPriceData
      .bind(onNext: self.setCoinDetailData)
      .disposed(by: self.disposeBag)
  }
  
  private func setCoinDetailData(with coinPriceData: CoinPriceData) {
    self.currentPriceLabel.attributedText = self.currentPriceText(with: coinPriceData)
    self.priceDifferenceLabel.attributedText = self.priceDifferenceText(with: coinPriceData)
    self.priceChangedRatioLabel.attributedText = self.priceChangedRatioText(with: coinPriceData)
  }
}


// MARK: - Edit PriceData Text

extension CurrentPriceStatusView: PriceDataTextEditable { }
