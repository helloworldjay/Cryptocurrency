//
//  ChartCoordinator.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

import Then

final class CoinDetailCoordinator: Coordinator {

  // MARK: Properties

  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  var orderCurrency: OrderCurrency
  var paymentCurrency: PaymentCurrency


  // MARK: - Initializers

  init(navigationController: UINavigationController, orderCurrency: OrderCurrency, paymentCurrency: PaymentCurrency) {
    self.navigationController = navigationController
    self.orderCurrency = orderCurrency
    self.paymentCurrency = paymentCurrency

    self.start()
  }
  
  func start() {
    let coinDetailViewController = CoinDetailViewController(
      payload: CoinDetailViewController.Payload(
        orderCurrency: self.orderCurrency,
        paymentCurrency: self.paymentCurrency
      )
    ).then {
      $0.coinDetailViewModel.coinDetailCoordinator = self
    }
    self.navigationController.pushViewController(coinDetailViewController, animated: false)
  }
  
  
  // MARK: Presentations
  
  func presentTimeUnitBottomSheet(with timeUnit: TimeUnit) {
    guard let coinDetailViewController = self.navigationController.viewControllers.last else { return }
    let timeUnitBottomCoordinator = TimeUnitBottomSheetCoordinator(presentingViewController: coinDetailViewController, timeUnit: timeUnit)
    timeUnitBottomCoordinator.parentCoordinator = self
    self.childCoordinators.append(timeUnitBottomCoordinator)
  }
}
