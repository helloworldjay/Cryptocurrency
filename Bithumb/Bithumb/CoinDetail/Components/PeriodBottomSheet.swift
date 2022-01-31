//
//  PeriodBottomSheet.swift
//  Bithumb
//
//  Created by 이영우 on 2022/01/31.
//

import UIKit

import SnapKit
import Then

final class PeriodBottomSheet: BottomSheet {
  
  // MARK: Properties
  
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let periodListView = UITableView()
  private let cancelButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.layout()
    self.attribute()
  }
  
  private func layout() {
    [self.titleLabel, self.descriptionLabel, self.periodListView, self.cancelButton].forEach {
      self.bottomSheetView.addSubview($0)
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().inset(20)
      $0.trailing.equalTo(self.cancelButton.snp.leading)
    }
    
    self.descriptionLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
    }
    
    self.cancelButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.top.bottom.equalTo(self.titleLabel)
      $0.width.equalTo(self.cancelButton.snp.height)
    }
    
    self.periodListView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(20)
    }
    
    self.defaultHeight = 320
  }
  
  private func attribute() {
    self.titleLabel.do {
      $0.text = "봉 기간 설정"
      $0.font = .systemFont(ofSize: 18)
    }
    
    self.descriptionLabel.do {
      $0.text = "차트 봉 기간 설정"
      $0.font = .systemFont(ofSize: 12)
      $0.textColor = .gray
    }
    
    self.cancelButton.do {
      $0.setBackgroundImage(UIImage(systemName: "xmark"),
                            for: .normal)
      $0.tintColor = .black
      $0.addTarget(self,
                   action: #selector(self.tapCancelButton),
                   for: .touchUpInside)
    }
    
    self.periodListView.do {
      $0.separatorStyle = .none
      $0.register(UITableViewCell.self,
                  forCellReuseIdentifier: "cell")
      $0.isScrollEnabled = false
    }
  }
  
  @objc private func tapCancelButton() {
    self.hideBottomSheetAndGoBack()
  }
}