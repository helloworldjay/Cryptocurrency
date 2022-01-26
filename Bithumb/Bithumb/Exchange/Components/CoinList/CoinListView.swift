//
//  CoinListView.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

final class CoinListView: UITableView {
  
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
    self.backgroundColor = .white
    self.register(CoinListViewCell.self, forCellReuseIdentifier: "CoinListViewCell")
    self.separatorStyle = .singleLine
    self.rowHeight = 100
  }
  
  func bind(viewModel: CoinListViewModel) {
    viewModel.cellData
      .drive(self.rx.items) { tableView, row, data in
        let index = IndexPath(row: row, section: 0)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinListViewCell", for: index) as? CoinListViewCell else { return CoinListViewCell() }
        cell.setData(with: data)
        return cell
      }.disposed(by: disposeBag)
  }
}
