//
//  CoinListView.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/20.
//

import RxCocoa
import RxSwift

final class CoinListView: UITableView {

  // MARK: Properties

  let coinListSortView = CoinListSortView(
    frame: CGRect(
      origin: .zero,
      size: CGSize(width: UIScreen.main.bounds.width, height: 30)
    )
  )
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
    self.tableHeaderView = self.coinListSortView
    self.register(CoinListViewCell.self, forCellReuseIdentifier: "CoinListViewCell")
    self.separatorStyle = .singleLine
    self.rowHeight = 60
  }

  func bind(viewModel: CoinListViewModelLogic) {
    viewModel.cellData
      .drive(self.rx.items) { tableView, row, data in
        return self.customizedCoinListViewCell(with: row, and: data)
      }.disposed(by: self.disposeBag)

    viewModel.socketTickerData
      .filter { $0 != nil }
      .map { $0! }
      .drive(onNext: { socketTickerData in
        guard let tickerName = viewModel.tickerName(from: socketTickerData),
              let coinListViewCellData = viewModel.coinListViewCellData(from: socketTickerData) else { return }
        self.updateCell(with: tickerName, and: coinListViewCellData)
      }).disposed(by: self.disposeBag)

    self.rx.modelSelected(CoinListViewCellData.self)
      .map { $0.ticker }
      .map { OrderCurrency.search(with: $0) }
      .bind(to: viewModel.selectedOrderCurrency)
      .disposed(by: self.disposeBag)
  }

  private func customizedCoinListViewCell(with row: Int, and data: CoinListViewCellData) -> CoinListViewCell {
    let index = IndexPath(row: row, section: 0)
    guard let cell = self.dequeueReusableCell(withIdentifier: "CoinListViewCell", for: index)
            as? CoinListViewCell else { return CoinListViewCell() }
    cell.setData(with: data)
    cell.selectionStyle = .none
    return cell
  }

  private func updateCell(with tickerName: String, and coinListViewCellData: CoinListViewCellData) {
    let numberOfRows = self.numberOfRows(inSection: 0)
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
  }
}
