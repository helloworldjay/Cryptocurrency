//
//  BottomSheet.swift
//  Bithumb
//
//  Created by 이영우 on 2022/01/31.
//

import UIKit

import SnapKit
import Then

class BottomSheet: UIViewController {
  
  // MARK: Properties
  
  private let dimmedTap = UITapGestureRecognizer()
  private let dimmedView = UIView()
  
  let bottomSheetView = UIView()
  var defaultHeight: CGFloat = 300
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.attribute()
    self.layout()
  }
  
  private func attribute() {
    self.bottomSheetView.do {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 10
      $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                .layerMaxXMinYCorner]
      $0.clipsToBounds = true
    }
    
    self.dimmedTap.do {
      $0.addTarget(self, action: #selector(self.dimmedViewTapped))
    }
    
    self.dimmedView.do {
      $0.backgroundColor = .darkGray.withAlphaComponent(0.7)
      $0.addGestureRecognizer(self.dimmedTap)
      $0.isUserInteractionEnabled = true
    }
  }
  
  @objc private func dimmedViewTapped() {
    self.hideBottomSheetAndGoBack()
  }
  
  func hideBottomSheetAndGoBack() {
    self.bottomSheetView.snp.remakeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.snp.bottom).offset(self.defaultHeight)
      $0.top.equalTo(self.view.snp.bottom)
    }
    
    UIView.animate(withDuration: 0.25,
                   delay: 0,
                   options: .curveEaseIn) { [weak self] in
      self?.view.layoutIfNeeded()
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }
  
  private func layout() {
    self.view.addSubview(self.dimmedView)
    self.view.addSubview(self.bottomSheetView)
    
    self.bottomSheetView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.snp.bottom).offset(self.defaultHeight)
      $0.top.equalTo(self.view.snp.bottom)
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
    self.bottomSheetView.snp.remakeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.snp.bottom)
      $0.top.equalTo(self.view.snp.bottom).inset(self.defaultHeight)
    }
    
    UIView.animate(withDuration: 0.25,
                   delay: 0,
                   options: .curveEaseIn) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }
}
