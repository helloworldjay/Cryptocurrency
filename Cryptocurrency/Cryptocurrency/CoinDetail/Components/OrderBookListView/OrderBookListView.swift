//
//  OrderBookListView.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/07.
//

import UIKit

import RxCocoa
import RxSwift

final class OrderBookListView: UITableView {

  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  
  
  // MARK: Initializers
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    
    self.attribute()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {
    self.register(OrderBookListViewCell.self, forCellReuseIdentifier: "OrderBookListViewCell")
    self.backgroundColor = .white
    self.separatorStyle = .none
    self.allowsSelection = false
    self.rowHeight = 40
  }
  
  func bind(viewModel: OrderBookListViewModelLogic) {
    viewModel.cellData
      .bind(to: self.rx.items) { tableView, row, data in
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: "OrderBookListViewCell",
          for: indexPath
        ) as? OrderBookListViewCell else {
          return OrderBookListViewCell()
        }
        cell.setData(with: data)
        return cell
      }.disposed(by: self.disposeBag)
    
    viewModel.cellData
      .bind { orderBookListViewCellData in
        let centerIndex = orderBookListViewCellData.count / 2
        self.scrollToRow(at: IndexPath(row: centerIndex, section: .zero),
                         at: .middle, animated: false)
      }.disposed(by: self.disposeBag)
  }
}
