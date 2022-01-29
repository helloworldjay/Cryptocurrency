//
//  MoreOptionCoordinator.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

final class MoreOptionCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  init() {
    self.navigationController = .init()

    self.start()
  }

  func start() {
    let moreOptionViewController = MoreOptionViewController()
    self.navigationController.setViewControllers(
      [moreOptionViewController],
      animated: false
    )
  }

  func pushNavigationController() -> UINavigationController {
    return self.navigationController
  }
}
