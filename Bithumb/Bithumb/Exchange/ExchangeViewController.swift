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
  
  private let exchangeSearchBar = ExchangeSearchBar()
  
  private let giftButton = UIButton(frame: CGRect(
     x: 0,
     y: 0,
     width: 30,
     height: 20
   )).then {
     let giftImage = UIImage(systemName: "gift")
     $0.setImage(giftImage, for: .normal)
     $0.tintColor = .black
   }
  
   private let bellButton = UIButton(frame: CGRect(
     x: 0,
     y: 0,
     width: 30,
     height: 20
   )).then {
     let bellImage = UIImage(systemName: "bell")
     $0.setImage(bellImage, for: .normal)
     $0.tintColor = .black
   }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout()
  }
  
  private func layout() {
    self.navigationItem.do {
      $0.titleView = self.exchangeSearchBar
      $0.rightBarButtonItems = [
        UIBarButtonItem(customView: self.bellButton),
        UIBarButtonItem(customView: self.giftButton)
      ]
    }
  }
}
