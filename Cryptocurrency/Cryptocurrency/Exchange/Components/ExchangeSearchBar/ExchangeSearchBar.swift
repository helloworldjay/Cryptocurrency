//
//  ExchangeSearchBar.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ExchangeSearchBar: UISearchBar {

  //MARK:  Properties
  
  private let giftButton = UIButton().then {
    $0.setImage(UIImage(systemName: "gift"), for: .normal)
    $0.tintColor = .black
  }
  
  private let bellButton = UIButton().then {
    $0.setImage(UIImage(systemName: "bell"), for: .normal)
    $0.tintColor = .black
  }

  private let exchangeSearchBarViewModel = ExchangeSearchBarViewModel()
  private let disposeBag = DisposeBag()


  // MARK: Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configure()
    self.layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    self.searchTextField.do {
      $0.layer.borderWidth = 2
      $0.layer.borderColor = UIColor.signature.cgColor
      $0.layer.cornerRadius = 10
      $0.leftView?.tintColor = .black
      $0.backgroundColor = .systemBackground
      $0.placeholder = "코인명 또는 심볼 검색"
      $0.tintColor = UIColor.signature
    }
  }

  private func layout() {
    [giftButton, bellButton].forEach {
      self.addSubview($0)
    }
    
    self.searchTextField.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(12)
      $0.trailing.equalTo(self.giftButton.snp.leading).offset(-12)
      $0.centerY.equalToSuperview()
    }
    
    self.giftButton.snp.makeConstraints {
      $0.trailing.equalTo(self.bellButton.snp.leading).offset(-12)
      $0.centerY.equalToSuperview()
    }
    
    self.bellButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-12)
      $0.centerY.equalToSuperview()
    }
  }

  func bind(viewModel: ExchangeSearchBarViewModelLogic) {
    self.rx.text.orEmpty
      .bind(to: viewModel.inputText)
      .disposed(by: self.disposeBag)
    
    self.rx.searchButtonClicked
      .asSignal()
      .emit(to: self.rx.endEditing)
      .disposed(by: self.disposeBag)
  }
}


// MARK: - Reactive Extension

extension Reactive where Base: ExchangeSearchBar {
  var endEditing: Binder<Void> {
    return Binder(base) { base, _ in
      base.endEditing(true)
    }
  }
}
