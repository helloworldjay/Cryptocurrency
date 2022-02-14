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

  let sortByNameButton = SortButton()
  let sortByCurrentPriceButton = SortButton()
  let sortByPriceChangedRatioButton = SortButton()
  let sortByTransactionAmountButton = SortButton()
  let divider = UIView().then {
    $0.backgroundColor = .gray
  }
  private let disposeBag = DisposeBag()


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
    self.sortByNameButton.do {
      $0.setTitle("가산자산명", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15)
      $0.contentHorizontalAlignment = .left
      $0.addTarget(self, action: #selector(self.sortButtonTapped), for: .touchUpInside)
    }
    self.sortByCurrentPriceButton.do {
      $0.setTitle("현재가", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15)
      $0.contentHorizontalAlignment = .right
      $0.addTarget(self, action: #selector(self.sortButtonTapped), for: .touchUpInside)
    }
    self.sortByPriceChangedRatioButton.do {
      $0.setTitle("변동률", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15)
      $0.contentHorizontalAlignment = .right
      $0.addTarget(self, action: #selector(self.sortButtonTapped), for: .touchUpInside)
    }
    self.sortByTransactionAmountButton.do {
      $0.setTitle("거래금액", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15)
      $0.contentHorizontalAlignment = .right
      $0.addTarget(self, action: #selector(self.sortButtonTapped), for: .touchUpInside)
    }

    self.setSelectedButton(with: self.sortByTransactionAmountButton)

    [
      self.sortByNameButton,
      self.sortByCurrentPriceButton,
      self.sortByPriceChangedRatioButton
    ].forEach {
      self.setUnselectedButton(with: $0)
    }
  }

  @objc
  private func sortButtonTapped(sortButton: SortButton) {
    [
      self.sortByNameButton,
      self.sortByCurrentPriceButton,
      self.sortByPriceChangedRatioButton,
      self.sortByTransactionAmountButton
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
      self.sortByNameButton,
      self.sortByCurrentPriceButton,
      self.sortByPriceChangedRatioButton,
      self.sortByTransactionAmountButton,
      self.divider
    ].forEach { addSubview($0) }

    self.sortByNameButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(12)
      $0.width.equalToSuperview().multipliedBy(0.3)
    }

    self.sortByCurrentPriceButton.snp.makeConstraints {
      $0.centerY.equalTo(self.sortByNameButton)
      $0.trailing.equalToSuperview().multipliedBy(0.5)
    }

    self.sortByPriceChangedRatioButton.snp.makeConstraints {
      $0.centerY.equalTo(self.sortByNameButton)
      $0.trailing.equalToSuperview().multipliedBy(0.7)
    }

    self.sortByTransactionAmountButton.snp.makeConstraints {
      $0.centerY.equalTo(self.sortByNameButton)
      $0.trailing.equalToSuperview().inset(12)
    }

    self.divider.snp.makeConstraints {
      $0.height.equalTo(0.5)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }

  func bind(coinListSortViewModel: CoinListSortViewModelLogic) {
    self.sortByNameButton.rx.tap
      .map {
        return (self.sortByNameButton.isDescending, CoinListSortCriterion.coinName)
      }.bind(to: coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)

    self.sortByCurrentPriceButton.rx.tap
      .map {
        return (self.sortByCurrentPriceButton.isDescending, CoinListSortCriterion.currentPrice)
      }.bind(to: coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)

    self.sortByPriceChangedRatioButton.rx.tap
      .map {
        return (self.sortByPriceChangedRatioButton.isDescending, CoinListSortCriterion.priceChangedRatio)
      }.bind(to: coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)

    self.sortByTransactionAmountButton.rx.tap
      .map {
        return (self.sortByTransactionAmountButton.isDescending, CoinListSortCriterion.transactionAmount)
      }.bind(to: coinListSortViewModel.coinListSortCriteria)
      .disposed(by: self.disposeBag)
  }
}
