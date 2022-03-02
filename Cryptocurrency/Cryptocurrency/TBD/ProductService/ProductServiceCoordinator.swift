//
//  ProductServiceCoordinator.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

final class ProductServiceCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator]
  private var navigationController: UINavigationController

  init() {
    self.childCoordinators = []
    self.navigationController = .init()

    self.start()
  }

  func start() {
    let productServiceViewController = ProductServiceViewController()
    self.navigationController.setViewControllers(
      [productServiceViewController],
      animated: false
    )
  }

  func pushNavigationController() -> UINavigationController {
    return self.navigationController
  }
}
