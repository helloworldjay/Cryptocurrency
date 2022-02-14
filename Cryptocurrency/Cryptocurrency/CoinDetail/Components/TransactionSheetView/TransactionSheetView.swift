//
//  TransactionHistorySheetView.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/12.
//

import UIKit

import RxCocoa
import RxSwift
import Then

final class TransactionSheetView: UIView {
  
  // MARK: Properties
  
  private let transactionListView = UITableView()
  private let timeCategoryLabel = UILabel()
  private let priceCategoryLabel = UILabel()
  private let transactionCategoryLabel = UILabel()
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializer
  
  init() {
    super.init(frame: .zero)
    
    self.layout()
    self.attribute()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    [self.transactionListView,
     self.timeCategoryLabel,
     self.priceCategoryLabel,
     self.transactionCategoryLabel].forEach {
      self.addSubview($0)
    }
    
    self.timeCategoryLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
      $0.width.equalTo(80)
      $0.height.equalTo(30)
    }
    
    self.priceCategoryLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalTo(self.timeCategoryLabel.snp.trailing)
      $0.width.equalTo(self.transactionCategoryLabel)
      $0.height.equalTo(self.timeCategoryLabel)
    }
    
    self.transactionCategoryLabel.snp.makeConstraints {
      $0.top.trailing.equalToSuperview()
      $0.leading.equalTo(self.priceCategoryLabel.snp.trailing)
      $0.height.equalTo(self.timeCategoryLabel)
    }
    
    self.transactionListView.snp.makeConstraints {
      $0.top.equalTo(timeCategoryLabel.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func attribute() {
    self.transactionListView.do {
      $0.register(TransactionSheetViewCell.self, forCellReuseIdentifier: "TransactionSheetViewCell")
      $0.allowsSelection = false
      $0.rowHeight = 40
    }
    
    self.timeCategoryLabel.text = "시간"
    self.priceCategoryLabel.text = "가격"
    self.transactionCategoryLabel.text = "체결량"

    [self.timeCategoryLabel, self.priceCategoryLabel, self.transactionCategoryLabel].forEach {
      $0.textAlignment = .center
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.layer.borderWidth = 0.4
      $0.font = .systemFont(ofSize: 12)
    }
  }
  
  
  // MARK: Binding
  
  func bind(transactionSheetViewModel: TransactionSheetViewModelLogic) {
    transactionSheetViewModel.cellData
      .drive(self.transactionListView.rx.items) { tableView, row, data in
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: "TransactionSheetViewCell",
          for: indexPath
        ) as? TransactionSheetViewCell else {
          return TransactionSheetViewCell()
        }
        cell.setData(with: data)
        return cell
      }.disposed(by: self.disposeBag)
  }
}
