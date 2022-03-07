//
//  TimeUnitBottomSheet.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/01/31.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class TimeUnitBottomSheet: BottomSheet {

  // MARK: Properties
  
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let timetUnitListView = UITableView()
  private let cancelButton = UIButton()
  
  private let disposeBag = DisposeBag()
  var timeUnitViewModel: TimeUnitBottomSheetViewModelLogic

  
  // MARK: Initializer
  
  init(timeUnitViewModel: TimeUnitBottomSheetViewModelLogic) {
    self.timeUnitViewModel = timeUnitViewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.layout()
    self.attribute()
    self.bind()
  }
  
  private func layout() {
    [self.titleLabel, self.descriptionLabel, self.timetUnitListView, self.cancelButton].forEach {
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
    
    self.timetUnitListView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(20)
    }
    
    self.defaultHeight = 500
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
    
    self.timetUnitListView.do {
      $0.separatorStyle = .none
      $0.register(UITableViewCell.self,
                  forCellReuseIdentifier: "timeUnitListViewCell")
      $0.isScrollEnabled = false
    }
  }
  
  @objc private func tapCancelButton() {
    self.hideBottomSheetAndGoBack()
  }
  
  private func bind() {
    Observable.just(self.timeUnitViewModel.units)
      .bind(to: self.timetUnitListView.rx.items) { (tableView, row, element) in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeUnitListViewCell") else {
          return UITableViewCell()
        }
        cell.textLabel?.text = element.expression
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.tintColor = .signature
        if row == self.timeUnitViewModel.tapListView.value.row {
          cell.accessoryType = .checkmark
        }
        return cell
      }.disposed(by: self.disposeBag)
    
    self.timetUnitListView.rx.itemSelected
      .bind(to: self.timeUnitViewModel.tapListView)
      .disposed(by: self.disposeBag)
  }
}
