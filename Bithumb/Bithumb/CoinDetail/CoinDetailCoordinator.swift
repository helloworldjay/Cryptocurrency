//
//  ChartCoordinator.swift
//  Bithumb
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


  // MARK: - Initializers

  init(navigationController: UINavigationController, orderCurrency: OrderCurrency) {
    self.navigationController = navigationController
    self.orderCurrency = orderCurrency

    self.start()
  }
  
  func start() {
    let coinDetailViewController = CoinDetailViewController(
      payload: CoinDetailViewController.Payload(
        orderCurrency: self.orderCurrency
      )
    ).then {
      $0.coinDetailViewModel.coinDetailCoordinator = self
    }
    self.navigationController.pushViewController(coinDetailViewController, animated: false)
  }
  
  
  // MARK: Presentations
  
  func presentTimeIntervalBottomSheet(with timeInterval: TimeInterval) {
    guard let coinDetailViewController = self.navigationController.viewControllers.last else { return }
    let timeIntervalCoordinator = TimeIntervalBottomSheetCoordinator(presentingViewController: coinDetailViewController,
                                                                     timeInterval: timeInterval)
    timeIntervalCoordinator.parentCoordinator = self
    self.childCoordinators.append(timeIntervalCoordinator)
  }
}
