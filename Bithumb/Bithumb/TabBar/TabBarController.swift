//
//  TabBarController.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/19.
//

import UIKit

import Then

class TabBarController: UITabBarController {
  
  // MARK: Properties
  
  private var defaultIndex = 0 {
    didSet {
      self.selectedIndex = defaultIndex
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.attribute()
    self.layout()
  }
  
  private func attribute() {
    self.tabBar.do {
      $0.tintColor = .black
      $0.unselectedItemTintColor = .gray
    }
    self.view.backgroundColor = .white
    
    UITabBarItem.appearance().setTitleTextAttributes(
      [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
      for: .normal
    )
  }
  
  private func layout() {
    let exchangeViewController = UINavigationController(
      rootViewController: ExchangeViewController()
    ).then {
      $0.tabBarItem.image = UIImage(systemName: "alternatingcurrent")
      $0.tabBarItem.title = "거래소"
    }
    
    let productServiceViewController = ProductServiceViewController().then {
      $0.tabBarItem.image = UIImage(systemName: "cart")
      $0.tabBarItem.title = "상품/서비스"
    }
    
    let currentAssetViewController = CurrentAssetViewController().then {
      $0.tabBarItem.image = UIImage(systemName: "wallet.pass")
      $0.tabBarItem.title = "자산현황"
    }
    
    let transactionViewController = TransactionViewController().then {
      $0.tabBarItem.image = UIImage(systemName: "arrow.up.right.and.arrow.down.left.rectangle")
      $0.tabBarItem.title = "입출금"
    }
    
    let moreOptionViewController = MoreOptionViewController().then {
      $0.tabBarItem.image = UIImage(systemName: "ellipsis")
      $0.tabBarItem.title = "더보기"
    }
    
    self.viewControllers = [
      exchangeViewController,
      productServiceViewController,
      currentAssetViewController,
      transactionViewController,
      moreOptionViewController
    ]
  }
}
