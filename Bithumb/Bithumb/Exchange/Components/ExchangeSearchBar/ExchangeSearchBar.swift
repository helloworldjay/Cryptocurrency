//
//  ExchangeSearchBar.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import UIKit

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
  
  
  // MARK: Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    configure()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    self.addSubview(giftButton)
    self.addSubview(bellButton)
    
    self.searchTextField.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(12)
      $0.trailing.equalTo(giftButton.snp.leading).offset(-12)
      $0.centerY.equalToSuperview()
    }
    
    self.giftButton.snp.makeConstraints {
      $0.trailing.equalTo(bellButton.snp.leading).offset(-12)
      $0.centerY.equalToSuperview()
    }
    
    self.bellButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-12)
      $0.centerY.equalToSuperview()
    }
  }
  
  private func configure() {
    self.searchTextField.do {
      $0.layer.borderWidth = 2
      $0.layer.borderColor = UIColor.bithumb.cgColor
      $0.layer.cornerRadius = 10
      $0.leftView?.tintColor = .black
      $0.backgroundColor = .systemBackground
      $0.placeholder = "코인명 또는 심볼 검색"
      $0.tintColor = UIColor.bithumb
    }
  }
}
