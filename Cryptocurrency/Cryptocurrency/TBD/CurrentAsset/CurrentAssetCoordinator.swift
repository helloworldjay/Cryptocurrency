//
//  CurrentAssetCoordinator.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

final class CurrentAssetCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator]
  private var navigationController: UINavigationController

  init() {
    self.childCoordinators = []
    self.navigationController = .init()

    self.start()
  }

  func start() {
    let currentAssetViewController = CurrentAssetViewController()
    self.navigationController.setViewControllers(
      [currentAssetViewController],
      animated: false
    )
  }

  func currentAssetNavigationController() -> UINavigationController {
    return self.navigationController
  }
}
