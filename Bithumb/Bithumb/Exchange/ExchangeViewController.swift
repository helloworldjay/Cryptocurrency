//
//  ExchangeViewController.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/19.
//

import UIKit

import Then

final class ExchangeViewController: UIViewController {
  
  // MARK: Properties
  
  let exchangeSearchBar = ExchangeSearchBar()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout()
  }
  
  private func layout() {
    self.navigationItem.do {
      $0.titleView = self.exchangeSearchBar
    }
  }
  
}
