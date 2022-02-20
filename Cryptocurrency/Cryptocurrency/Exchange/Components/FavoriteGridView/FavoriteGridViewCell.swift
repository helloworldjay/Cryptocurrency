//
//  FavoriteGirdViewCell.swift
//  Cryptocurrency
//
//  Created by 김민성 on 2022/02/17.
//

import UIKit

import SnapKit
import Then

class FavoriteGridViewCell: UICollectionViewCell {

  // MARK: Properties

  private let containerView = UIView()
  private let coinTitleLabel  = UILabel()
  private let tickerLabel = UILabel()
  private let titleStackView = UIStackView()
  private let favoriteImageView = UIImageView()

  override func layoutSubviews() {
    super.layoutSubviews()
    self.attribute()
    self.layout()
  }

  private func attribute() {
    self.do {
      $0.layer.borderWidth = 2
      $0.layer.borderColor = UIColor.signature.cgColor
      $0.layer.cornerRadius = 12
    }

    self.favoriteImageView.do {
      $0.image = UIImage(systemName: "star.fill")
      $0.tintColor = .signature
    }

    self.coinTitleLabel.do {
      $0.font = .systemFont(ofSize: 20)
      $0.numberOfLines = 2
      $0.lineBreakMode = .byCharWrapping
    }

    self.tickerLabel.do {
      $0.font = .systemFont(ofSize: 10)
      $0.textColor = .darkGray
    }

    self.titleStackView.do {
      $0.axis = .vertical
      $0.alignment = .center
      $0.spacing = 10
    }
  }

  private func layout() {
    [self.favoriteImageView ,self.titleStackView].forEach {
      self.contentView.addSubview($0)
    }

    [self.coinTitleLabel, self.tickerLabel].forEach {
      self.titleStackView.addArrangedSubview($0)
    }

    self.favoriteImageView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(10)
    }

    self.titleStackView.snp.makeConstraints {
      $0.center.equalTo(self.contentView)
    }
  }

  func setData(with data: FavoriteGridViewCellData) {
    self.coinTitleLabel.text = data.coinName
    self.tickerLabel.text = data.ticker + "/" + data.paymentCurrency
  }
}
