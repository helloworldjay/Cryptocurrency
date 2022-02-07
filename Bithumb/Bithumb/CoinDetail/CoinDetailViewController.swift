//
//  CoinDetailViewController.swift
//  Bithumb
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
  private let coinChartView: CoinChartView
  private let timeUnitChangeButton: UIButton
  private let priceChangedRatioLabel : UILabel
  private let priceDifferenceLabel : UILabel
  private let currentPriceLabel: UILabel
  
  
  // MARK: Initializers

  init(payload: Payload) {
    self.payload = payload
    self.coinDetailViewModel = CoinDetailViewModel(orderCurrency: payload.orderCurrency,
                                                   paymentCurrency: payload.paymentCurrency)
    self.coinDetailSegmentedCategoryView = CoinDetailSegmentedCategoryView()
    self.coinChartView = CoinChartView()
    self.orderBookListView = OrderBookListView()
    self.timeUnitChangeButton = UIButton()
    self.priceChangedRatioLabel = UILabel()
    self.priceDifferenceLabel = UILabel()
    self.currentPriceLabel = UILabel()
    self.disposeBag = DisposeBag()
    
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
     self.currentPriceLabel,
     self.priceDifferenceLabel,
     self.priceChangedRatioLabel,
     self.orderBookListView].forEach { self.view.addSubview($0) }
    
    self.coinDetailSegmentedCategoryView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(10)
      $0.top.equalTo(self.priceDifferenceLabel.snp.bottom).offset(10)
    }
    
    self.coinChartView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.coinDetailSegmentedCategoryView.snp.bottom)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.orderBookListView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.coinDetailSegmentedCategoryView.snp.bottom).offset(10)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.timeUnitChangeButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.bottom.equalTo(self.coinChartView.snp.top)
    }
    
    self.currentPriceLabel.snp.makeConstraints {
      $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }
    
    self.priceDifferenceLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(10)
      $0.top.equalTo(self.currentPriceLabel.snp.bottom).offset(10)
    }
    
    self.priceChangedRatioLabel.snp.makeConstraints {
      $0.leading.equalTo(self.priceDifferenceLabel.snp.trailing).offset(10)
      $0.centerY.equalTo(self.priceDifferenceLabel.snp.centerY)
    }
  }
  
  private func attribute() {
    self.title = payload.orderCurrency.koreanName
    self.coinChartView.isHidden = false
    self.currentPriceLabel.font = .preferredFont(forTextStyle: .largeTitle)
    
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
    self.coinChartView.bind(viewModel: self.coinDetailViewModel.coinChartViewModel)

    self.timeUnitChangeButton.rx.tap
      .bind(to: self.coinDetailViewModel.tapSelectTimeUnitButton)
      .disposed(by: self.disposeBag)
    
    self.coinDetailViewModel.selectedTimeUnit
      .bind {
        self.timeUnitChangeButton.setTitle($0.rawValue, for: .normal)
      }.disposed(by: self.disposeBag)
    
    self.coinDetailViewModel.coinDetailData
      .bind { coinDetailData in
        self.setCoinDetailData(coinDetailData)
      }.disposed(by: self.disposeBag)
  }

  private func setCoinDetailData(_ coinDetailData: CoinDetailData?) {
    self.currentPriceLabel.attributedText = coinDetailData?.currentPriceText()
    self.priceDifferenceLabel.attributedText = coinDetailData?.priceDifferenceText()
    self.priceChangedRatioLabel.attributedText = coinDetailData?.priceChangedRatioText()
  }
}
