//
//  FavoriteGridView.swift
//  Cryptocurrency
//
//  Created by 김민성 on 2022/02/17.
//

import RxCocoa
import RxSwift

class FavoriteGridView: UICollectionView {

  // MARK: Properties

  private let disposeBag = DisposeBag()

  // MARK: Initializers

  init() {
    let customFlowLayout = UICollectionViewFlowLayout()
    customFlowLayout.scrollDirection = .vertical
    let size = (UIScreen.main.bounds.size.width - CGFloat(80)) / CGFloat(2)
    customFlowLayout.itemSize = CGSize(width: size, height: size)
    customFlowLayout.minimumLineSpacing = 25

    super.init(frame: .zero, collectionViewLayout: customFlowLayout)

    attribute()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func attribute() {
    self.backgroundColor = .white
    self.contentInset = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
    self.register(FavoriteGridViewCell.self, forCellWithReuseIdentifier: "FavoriteGridViewCell")

  }

  func bind(viewModel: FavoriteGridViewModel) {
    viewModel.cellData
      .drive(self.rx.items) { collectionView, row, data in
        let index = IndexPath(row: row, section: 0)
        print(data)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteGridViewCell", for: index) as? FavoriteGridViewCell else { return FavoriteGridViewCell() }
        cell.setData(with: data)

        return cell
      }.disposed(by: self.disposeBag)

    self.rx.modelSelected(FavoriteGridViewCellData.self)
      .map {
        (orderCurrency: OrderCurrency.search(with: $0.ticker),
         paymentCurrency: PaymentCurrency.search(with: $0.paymentCurrency))
      }
      .bind(to: viewModel.selectedCellData)
      .disposed(by: self.disposeBag)
  }
}
