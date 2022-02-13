//
//  CoinListSortView.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/02/11.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class CoinListSortView: UITableViewHeaderFooterView {

  // MARK: Properties

  let sortByName = SortButton()
  let sortByCurrentPrice = SortButton()
  let sortByPriceChangedRatio = SortButton()
  let sortByTransactionAmount = SortButton()
  let disposeBag = DisposeBag()
  let divider = UIView().then {
    $0.backgroundColor = .gray
  }


  // MARK: Initializers

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    self.attribute()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func attribute() {
    self.sortByName.do {
      $0.setTitle("가산자산명", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15)
      $0.contentHorizontalAlignment = .left
      $0.addTarget(self, action: #selector(self.sortButtonTapped), for: .touchUpInside)
    }
    self.sortByCurrentPrice.do {
      $0.setTitle("현재가", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15)
      $0.contentHorizontalAlignment = .right
      $0.addTarget(self, action: #selector(self.sortButtonTapped), for: .touchUpInside)
    }
    self.sortByPriceChangedRatio.do {
      $0.setTitle("변동률", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15)
      $0.contentHorizontalAlignment = .right
      $0.addTarget(self, action: #selector(self.sortButtonTapped), for: .touchUpInside)
    }
    self.sortByTransactionAmount.do {
      $0.setTitle("거래금액", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15)
      $0.contentHorizontalAlignment = .right
      $0.addTarget(self, action: #selector(self.sortButtonTapped), for: .touchUpInside)
    }

    self.setSelectedButton(with: self.sortByTransactionAmount)

    [
      self.sortByName,
      self.sortByCurrentPrice,
      self.sortByPriceChangedRatio
    ].forEach {
      self.setUnselectedButton(with: $0)
    }
  }

  @objc
  private func sortButtonTapped(sortButton: SortButton) {
    [
      self.sortByName,
      self.sortByCurrentPrice,
      self.sortByPriceChangedRatio,
      self.sortByTransactionAmount
    ].filter { $0 != sortButton }
    .forEach { self.setUnselectedButton(with: $0) }

    self.setSelectedButton(with: sortButton)
  }

  private func setSelectedButton(with button: SortButton) {
    button.setTitleColor(.black, for: .normal)
    button.isDescending.toggle()
    let sortImage = button.isDescending ? UIImage(systemName: "arrow.down") : UIImage(systemName: "arrow.up")
    button.setImage(sortImage, for: .normal)
    button.tintColor = .black
    button.semanticContentAttribute = .forceRightToLeft
  }

  private func setUnselectedButton(with button: SortButton) {
    button.setTitleColor(.gray, for: .normal)
    button.isDescending = false
    let unSortedImage = UIImage(systemName: "arrow.up.arrow.down")
    button.setImage(unSortedImage, for: .normal)
    button.tintColor = .gray
    button.semanticContentAttribute = .forceRightToLeft
  }

  private func layout() {
    [
      self.sortByName,
      self.sortByCurrentPrice,
      self.sortByPriceChangedRatio,
      self.sortByTransactionAmount,
      self.divider
    ].forEach { addSubview($0) }

    self.sortByName.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(12)
      $0.width.equalToSuperview().multipliedBy(0.3)
    }

    self.sortByCurrentPrice.snp.makeConstraints {
      $0.centerY.equalTo(self.sortByName)
      $0.trailing.equalToSuperview().multipliedBy(0.5)
    }

    self.sortByPriceChangedRatio.snp.makeConstraints {
      $0.centerY.equalTo(self.sortByName)
      $0.trailing.equalToSuperview().multipliedBy(0.7)
    }

    self.sortByTransactionAmount.snp.makeConstraints {
      $0.centerY.equalTo(self.sortByName)
      $0.trailing.equalToSuperview().inset(12)
    }

    self.divider.snp.makeConstraints {
      $0.height.equalTo(0.5)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }

  func bind(coinListSortViewModel: CoinListSortViewModelLogic) {
    self.sortByName.rx.tap
      .map {
        return (self.sortByName.isDescending, CoinListSortCriterion.coinName)
      }.bind(to: coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)

    self.sortByCurrentPrice.rx.tap
      .map {
        return (self.sortByCurrentPrice.isDescending, CoinListSortCriterion.currentPrice)
      }.bind(to: coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)

    self.sortByPriceChangedRatio.rx.tap
      .map {
        return (self.sortByPriceChangedRatio.isDescending, CoinListSortCriterion.priceChangedRatio)
      }.bind(to: coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)

    self.sortByTransactionAmount.rx.tap
      .map {
        return (self.sortByTransactionAmount.isDescending, CoinListSortCriterion.transactionAmount)
      }.bind(to: coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)
  }
}
