//
//  AppCoordinator.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

final class AppCoordinator: Coordinator {

  // MARK: Properties

  var childCoordinators: [Coordinator] = []
  private let window: UIWindow?


  // MARK: Initializers

  init(window: UIWindow?) {
    self.window = window
    self.window?.makeKeyAndVisible()
  }

  func start() {
    self.window?.rootViewController = UITabBarController().then {
      $0.viewControllers = self.viewControllersOnTabBar()
      $0.tabBar.do {
        $0.tintColor = .black
        $0.unselectedItemTintColor = .gray
      }
      $0.view.backgroundColor = .white

      UITabBarItem.appearance().setTitleTextAttributes(
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
        for: .normal
      )
    }
  }

  private func viewControllersOnTabBar() -> [UIViewController] {
    let exchangeCoordinator = ExchangeCoordinator()
    exchangeCoordinator.parentCoordinator = self
    self.childCoordinators.append(exchangeCoordinator)
    let exchangeViewController = exchangeCoordinator.pushNavigationController().then {
      $0.tabBarItem = UITabBarItem(
        title: "거래소",
        image: UIImage(systemName: "alternatingcurrent"),
        tag: 0
      )
    }

    let productServiceCoordinator = ProductServiceCoordinator()
    productServiceCoordinator.parentCoordinator = self
    self.childCoordinators.append(productServiceCoordinator)
    let productServiceViewController = productServiceCoordinator.pushNavigationController().then {
      $0.tabBarItem = UITabBarItem(
        title: "상품/서비스",
        image: UIImage(systemName: "cart"),
        tag: 1
      )
    }

    let currentAssetCoordinator = CurrentAssetCoordinator()
    currentAssetCoordinator.parentCoordinator = self
    self.childCoordinators.append(currentAssetCoordinator)
    let currentAssetViewController = currentAssetCoordinator.pushNavigationController().then {
      $0.tabBarItem = UITabBarItem(
        title: "자산현황",
        image: UIImage(systemName: "wallet.pass"),
        tag: 2
      )
    }

    let transactionCoordinator = TransactionCoordinator()
    transactionCoordinator.parentCoordinator = self
    self.childCoordinators.append(transactionCoordinator)
    let transactionViewController = transactionCoordinator.pushNavigationController().then {
      $0.tabBarItem = UITabBarItem(
        title: "입출금",
        image: UIImage(systemName: "arrow.up.right.and.arrow.down.left.rectangle"),
        tag: 3
      )
    }

    let moreOptionCoordinator = MoreOptionCoordinator()
    moreOptionCoordinator.parentCoordinator = self
    self.childCoordinators.append(moreOptionCoordinator)
    let moreOptionViewController = moreOptionCoordinator.pushNavigationController().then {
      $0.tabBarItem = UITabBarItem(
        title: "더보기",
        image: UIImage(systemName: "ellipsis"),
        tag: 4
      )
    }

    return [
      exchangeViewController,
      productServiceViewController,
      currentAssetViewController,
      transactionViewController,
      moreOptionViewController
    ]
  }
}
