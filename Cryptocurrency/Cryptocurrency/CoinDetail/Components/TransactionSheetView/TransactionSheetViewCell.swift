//
//  TransactionSheetViewCell.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/12.
//

import UIKit

import SnapKit

final class TransactionSheetViewCell: UITableViewCell {

  // MARK: Properties

  private let timeLabel: PaddingLabel
  private let priceLabel: PaddingLabel
  private let volumeLabel: PaddingLabel


  // MARK: Initializer

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    self.timeLabel = PaddingLabel(padding: padding)
    self.priceLabel = PaddingLabel(padding: padding)
    self.volumeLabel = PaddingLabel(padding: padding)
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.layout()
    self.attribute()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func layout() {
    [self.timeLabel, self.priceLabel, self.volumeLabel].forEach {
      self.contentView.addSubview($0)
    }
    
    self.timeLabel.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
      $0.width.equalTo(80)
    }
    
    self.priceLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalTo(self.timeLabel.snp.trailing)
      $0.width.equalTo(self.volumeLabel)
    }
    
    self.volumeLabel.snp.makeConstraints {
      $0.top.bottom.trailing.equalToSuperview()
      $0.leading.equalTo(self.priceLabel.snp.trailing)
    }
    
    self.timeLabel.setContentHuggingPriority(.required, for: .horizontal)
    self.timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }

  private func attribute() {
    [self.timeLabel, self.priceLabel, self.volumeLabel].forEach {
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.layer.borderWidth = 0.3
      $0.font = .systemFont(ofSize: 12)
      $0.textColor = .black
    }

    self.timeLabel.textAlignment = .center
    self.priceLabel.textAlignment = .right
    self.volumeLabel.textAlignment = .right
  }


  // MARK: Set CellData

  func setData(with data: TransactionSheetViewCellData) {
    self.timeLabel.text = data.dateText
    self.priceLabel.attributedText = data.priceText()
    self.volumeLabel.attributedText = data.volumeText()
  }
}
