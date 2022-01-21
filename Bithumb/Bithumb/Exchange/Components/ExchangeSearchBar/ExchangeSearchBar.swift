//
//  ExchangeSearchBar.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import UIKit

import Then

final class ExchangeSearchBar: UISearchBar {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    attribute()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {
    self.searchTextField.do {
      $0.layer.borderWidth = 2
      $0.layer.borderColor = UIColor(red: 227/255, green: 129/255, blue: 30/255, alpha: 1).cgColor
      $0.layer.cornerRadius = 10
      $0.leftView?.tintColor = .black
      $0.backgroundColor = .systemBackground
      $0.placeholder = "코인명 또는 심볼 검색"
      $0.tintColor = UIColor(red: 227/255, green: 129/255, blue: 30/255, alpha: 1)
    }
  }
  
}
