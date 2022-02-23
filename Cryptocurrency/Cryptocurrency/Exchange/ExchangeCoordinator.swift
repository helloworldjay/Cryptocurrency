//
//  ExchangeCoordinator.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

final class ExchangeCoordinator: Coordinator {

  // MARK: Properties

  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController


  // MARK: Initializers

  init() {
    self.navigationController = .init()

    self.start()
  }

  func start() {
    let exchangeViewController = ExchangeViewController().then {
      $0.exchangeViewModel.exchangeCoordinator = self
    }
    self.navigationController.setViewControllers(
      [exchangeViewController],
      animated: false
    )
  }

  func exchangeNavigationController() -> UINavigationController {
    return self.navigationController
  }


  // MARK: Presentations

  func presentCoinDetailViewController(orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) {
    let coinDetailCoordinator = CoinDetailCoordinator(
      navigationController: self.navigationController,
      orderCurrency: orderCurrency,
      paymentCurrency: paymentCurrency
    )
    coinDetailCoordinator.parentCoordinator = self
    self.childCoordinators.append(coinDetailCoordinator)
  }
}
