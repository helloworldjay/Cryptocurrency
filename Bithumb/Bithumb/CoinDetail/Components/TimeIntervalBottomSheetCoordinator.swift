//
//  TimeIntervalBottomSheetCoordinator.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/02.
//

import UIKit

import RxSwift

final class TimeIntervalBottomSheetCoordinator: Coordinator {
  
  // MARK: Properties
  
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let presentingViewController: UIViewController

  private let timeInterval: TimeInterval
  private let disposeBag = DisposeBag()

  
  // MARK: Initializer
  
  init(presentingViewController: UIViewController, timeInterval: TimeInterval) {
    self.presentingViewController = presentingViewController
    self.timeInterval = timeInterval
    
    self.start()
  }
  
  func start() {
    let timeIntervalViewModel = TimeIntervalViewModel(timeInterval: self.timeInterval)
    
    let timeIntervalBottomSheet = TimeIntervalBottomSheet(
      timeIntervalViewModel: timeIntervalViewModel).then {
      $0.timeIntervalViewModel.timeIntervalBottomSheetCoordinator = self
      $0.modalPresentationStyle = .overFullScreen
    }

    self.presentingViewController.present(timeIntervalBottomSheet, animated: false)
  }
  
  func dismiss() {
    let presentedViewController = self.presentingViewController.presentedViewController
    presentedViewController?.dismiss(animated: false, completion: nil)
  }
}
