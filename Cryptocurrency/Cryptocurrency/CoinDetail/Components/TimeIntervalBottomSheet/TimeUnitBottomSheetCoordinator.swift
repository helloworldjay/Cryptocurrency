//
//  TimeUnitBottomSheetCoordinator.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/02.
//

import UIKit

import RxSwift

final class TimeUnitBottomSheetCoordinator: Coordinator {
  
  // MARK: Properties
  
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let presentingViewController: UIViewController

  private let timeUnit: TimeUnit
  private let disposeBag = DisposeBag()

  
  // MARK: Initializer
  
  init(presentingViewController: UIViewController, timeUnit: TimeUnit) {
    self.presentingViewController = presentingViewController
    self.timeUnit = timeUnit

    self.start()
  }
  
  func start() {
    let timeUnitViewModel = TimeUnitBottomSheetViewModel(timeUnit: self.timeUnit)

    let timeUnitBottomSheet = TimeUnitBottomSheet(
      timeUnitViewModel: timeUnitViewModel
    ).then {
      $0.timeUnitViewModel.timeUnitBottomSheetCoordinator = self
      $0.modalPresentationStyle = .overFullScreen
    }

    self.presentingViewController.present(timeUnitBottomSheet, animated: false)
    self.bind()
  }
  
  private func bind() {
    guard let coinDetailViewController = self.presentingViewController as? CoinDetailViewController else {
      return
    }
    
    guard let timeUnitBottomSheet = self.presentingViewController.presentedViewController as? TimeUnitBottomSheet else {
      return
    }
    
    timeUnitBottomSheet.timeUnitViewModel.selectedTimeUnit
      .bind(to: coinDetailViewController.coinDetailViewModel.selectedTimeUnit)
      .disposed(by: self.disposeBag)
  }
  
  func dismiss() {
    self.presentingViewController.dismiss(animated: false, completion: nil)
  }
}
