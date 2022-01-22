//
//  BottomSheetViewController.swift
//  Bithumb
//
//  Created by 이영우 on 2022/01/22.
//

import UIKit

import SnapKit
import Then

class BottomSheet: UIViewController {
  
  // MARK: Properties
  
  private let dimmedTap = UITapGestureRecognizer()
  private let dimmedView = UIView()
  private var bottomSheetViewTopConstraint: ConstraintMakerEditable?

  let bottomSheetView = UIView()
  var defaultHeight: CGFloat = 300
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.attribute()
    self.layout()
  }
  
  private func attribute() {
    bottomSheetView.do {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 10
      $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner]
      $0.clipsToBounds = true
    }
    
    dimmedTap.do {
      $0.addTarget(self, action: #selector(dimmedViewTapped))
    }
    
    dimmedView.do {
      $0.backgroundColor = .darkGray.withAlphaComponent(0.7)
      $0.addGestureRecognizer(dimmedTap)
      $0.isUserInteractionEnabled = true
    }
  }
  
  @objc private func dimmedViewTapped() {
    self.hideBottomSheetAndGoBack()
  }
  
  func hideBottomSheetAndGoBack() {
    self.bottomSheetViewTopConstraint?.constraint.update(inset: 0)
    
    UIView.animate(withDuration: 0.25,
                   delay: 0,
                   options: .curveEaseIn) { [weak self] in
      self?.view.layoutIfNeeded()
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }
  
  private func layout() {
    self.view.addSubview(dimmedView)
    self.view.addSubview(bottomSheetView)
    
    self.bottomSheetView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.snp_bottomMargin)
      self.bottomSheetViewTopConstraint = $0.top.equalTo(self.view.snp_bottomMargin)
    }
    
    self.dimmedView.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showBottomSheet()
  }
  
  private func showBottomSheet() {
    self.bottomSheetViewTopConstraint?.constraint.update(inset: defaultHeight)

    UIView.animate(withDuration: 0.25,
                   delay: 0,
                   options: .curveEaseIn) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }
}
