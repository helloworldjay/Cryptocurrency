//
//  CoinDetailViewController.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

import Charts
import RxSwift
import SnapKit
import Then

final class CoinDetailViewController: UIViewController {

  // MARK: Payload
  
  struct Payload {
    let orderCurrency: OrderCurrency
    let paymentCurrency: PaymentCurrency
  }


  // MARK: Properties
  
  let coinDetailViewModel: CoinDetailViewModel
  private let payload: Payload
  private let disposeBag: DisposeBag
  
  private let coinDetailSegmentedCategoryView: CoinDetailSegmentedCategoryView
  private let orderBookListView: OrderBookListView
  private let timeUnitChangeButton: UIButton
  private let coinChartView: CoinChartView
  private let currentPriceStatusView: CurrentPriceStatusView
  private let transactionSheetView: TransactionSheetView
  
  
  // MARK: Initializers

  init(payload: Payload) {
    self.coinDetailViewModel = CoinDetailViewModel(orderCurrency: payload.orderCurrency,
                                                   paymentCurrency: payload.paymentCurrency)
    self.payload = payload
    self.disposeBag = DisposeBag()
    self.coinDetailSegmentedCategoryView = CoinDetailSegmentedCategoryView()
    self.orderBookListView = OrderBookListView()
    self.timeUnitChangeButton = UIButton()
    self.coinChartView = CoinChartView()
    self.currentPriceStatusView = CurrentPriceStatusView()
    self.transactionSheetView = TransactionSheetView()
    
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.layout()
    self.attribute()
    self.configure()
  }
  
  private func layout() {
    [self.coinChartView,
     self.coinDetailSegmentedCategoryView,
     self.timeUnitChangeButton,
     self.currentPriceStatusView,
     self.orderBookListView,
     self.transactionSheetView].forEach { self.view.addSubview($0) }
    
    self.currentPriceStatusView.snp.makeConstraints {
      $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }
    
    self.coinDetailSegmentedCategoryView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(10)
      $0.top.equalTo(self.currentPriceStatusView.snp.bottom).offset(10)
    }
    
    self.coinChartView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(5)
      $0.top.equalTo(self.coinDetailSegmentedCategoryView.snp.bottom)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.orderBookListView.snp.makeConstraints {
      $0.top.equalTo(self.coinDetailSegmentedCategoryView.snp.bottom).offset(10)
      $0.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.transactionSheetView.snp.makeConstraints {
      $0.top.equalTo(self.coinDetailSegmentedCategoryView.snp.bottom).offset(10)
      $0.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.timeUnitChangeButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.bottom.equalTo(self.coinChartView.snp.top)
    }
  }
  
  private func attribute() {
    self.title = payload.orderCurrency.koreanName
    self.coinChartView.isHidden = false

    self.timeUnitChangeButton.do {
      $0.setTitleColor(.darkGray, for: .normal)
      $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
      $0.tintColor = .darkGray
    }
  }
  
  private func configure() {
    self.bind()
  }

  private func bind() {
    self.coinDetailSegmentedCategoryView.bind(viewModel: self.coinDetailViewModel.coinDetailSegmentedCategoryViewModel)
    self.coinChartView.bind(viewModel: self.coinDetailViewModel.coinChartViewModel)
    self.currentPriceStatusView.bind(viewModel: self.coinDetailViewModel.currentPriceStatusViewModel)
    self.orderBookListView.bind(viewModel: self.coinDetailViewModel.orderBookListViewModel)
    self.transactionSheetView.bind(viewModel: self.coinDetailViewModel.transactionSheetViewModel)

    self.timeUnitChangeButton.rx.tap
      .bind(to: self.coinDetailViewModel.tapSelectTimeUnitButton)
      .disposed(by: self.disposeBag)

    self.coinDetailViewModel.selectedTimeUnit
      .bind {
        self.timeUnitChangeButton.setTitle($0.rawValue, for: .normal)
      }.disposed(by: self.disposeBag)
    
    self.coinDetailViewModel.coinDetailSegmentedCategoryViewModel.category
      .bind(onNext: changeContentView)
      .disposed(by: self.disposeBag)
  }
  
  private func changeContentView(by category: CoinDetailCategory) {
    switch category {
    case .orderBook:
      self.orderBookListView.isHidden = false
      self.coinChartView.isHidden = true
      self.timeUnitChangeButton.isHidden = true
      self.transactionSheetView.isHidden = true
    case .chart:
      self.orderBookListView.isHidden = true
      self.coinChartView.isHidden = false
      self.timeUnitChangeButton.isHidden = false
      self.transactionSheetView.isHidden = true
    case .transactionHistory:
      self.orderBookListView.isHidden = true
      self.coinChartView.isHidden = true
      self.timeUnitChangeButton.isHidden = true
      self.transactionSheetView.isHidden = false
    }
  }
}
