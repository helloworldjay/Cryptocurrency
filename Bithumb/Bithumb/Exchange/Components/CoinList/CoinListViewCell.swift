//
//  CoinListViewCell.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import UIKit

import SnapKit

final class CoinListViewCell: UITableViewCell {
  
  // MARK: Properties
  
  static let reuseIdentifier = "CoinListViewCell"
  
  private let coinTitleLabel = UILabel()
  private let tickerLabel = UILabel()
  private let titleStackView = UIStackView()
  private let currentPriceLabel = UILabel()
  private let priceChangedRatioLabel = UILabel()
  private let priceDifferenceLabel = UILabel()
  private let transactionAmountLabel = UILabel()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.attribute()
    self.layout()
  }

  private func attribute() {
    self.coinTitleLabel.do {
      $0.font = .systemFont(ofSize: 12)
      $0.numberOfLines = 2
      $0.lineBreakMode = .byCharWrapping
    }
    
    self.tickerLabel.do {
      $0.font = .systemFont(ofSize: 8)
      $0.textColor = .darkGray
    }
    
    self.titleStackView.do {
      $0.axis = .vertical
      $0.spacing = 2
    }
    
    self.currentPriceLabel.do {
      $0.font = .systemFont(ofSize: 11)
    }
    
    self.priceChangedRatioLabel.do {
      $0.font = .systemFont(ofSize: 11)
    }
    
    self.priceDifferenceLabel.do {
      $0.font = .systemFont(ofSize: 7)
    }
    
    self.transactionAmountLabel.do {
      $0.font = .systemFont(ofSize: 12)
    }
  }
  
  private func layout() {
    [self.titleStackView, self.currentPriceLabel, self.priceChangedRatioLabel, self.priceDifferenceLabel, self.transactionAmountLabel].forEach {
      contentView.addSubview($0)
    }
    
    [self.coinTitleLabel, self.tickerLabel].forEach {
      self.titleStackView.addArrangedSubview($0)
    }
    
    self.titleStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(10)
    }

    self.currentPriceLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.coinTitleLabel)
      make.trailing.equalToSuperview().multipliedBy(0.6)
    }
    
    self.priceChangedRatioLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.coinTitleLabel)
      make.trailing.equalToSuperview().multipliedBy(0.75)
    }
    
    self.priceDifferenceLabel.snp.makeConstraints { make in
      make.trailing.equalTo(self.priceChangedRatioLabel)
      make.top.equalTo(self.priceChangedRatioLabel.snp.bottom)
    }
    
    self.transactionAmountLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.coinTitleLabel)
      make.trailing.equalToSuperview().inset(10)
    }
  }
}
