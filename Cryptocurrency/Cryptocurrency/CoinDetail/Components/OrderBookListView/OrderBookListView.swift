//
//  OrderBookListView.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/07.
//

import UIKit

import RxCocoa
import RxSwift

final class OrderBookListView: UITableView {

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
  
  func bind() {
    // TODO: 매개변수로 ViewModel을 받아와 Binding을 진행
  }
}

