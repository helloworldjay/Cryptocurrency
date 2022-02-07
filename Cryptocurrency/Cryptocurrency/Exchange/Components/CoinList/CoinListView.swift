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
    self.rowHeight = 60
  }
  
  func bind(viewModel: CoinListViewModelLogic) {
    viewModel.cellData
      .drive(self.rx.items) { tableView, row, data in
        let index = IndexPath(row: row, section: 0)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinListViewCell", for: index) as? CoinListViewCell else { return CoinListViewCell() }
        cell.setData(with: data)
        cell.selectionStyle = .none
        return cell
      }.disposed(by: self.disposeBag)

    viewModel.socketTickerData
      .subscribe(onNext: { socketTickerData in
        let numberOfRows = self.numberOfRows(inSection: 0)
        guard let tickerName = socketTickerData.ticker,
              let coinListViewCellData = socketTickerData.coinListViewCellData else { return }
        for row in 0..<numberOfRows {
          guard let cell = self.cellForRow(at: IndexPath(row: row, section: 0)) as? CoinListViewCell else { continue }
          if cell.hasSameTickerName(with: tickerName) {
            cell.setData(with: coinListViewCellData)
            cell.contentView.layer.do {
              $0.borderColor = UIColor.signature.cgColor
              $0.borderWidth = 3
            }
          } else {
            cell.contentView.layer.borderColor = UIColor.white.cgColor
          }
        }
      }).disposed(by: self.disposeBag)
    
    self.rx.modelSelected(CoinListViewCellData.self)
      .map { $0.ticker }
      .map { OrderCurrency.search(with: $0) }
      .bind(to: viewModel.selectedOrderCurrency)
      .disposed(by: self.disposeBag)
  }
}
