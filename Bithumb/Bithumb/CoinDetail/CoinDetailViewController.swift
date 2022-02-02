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

  // TODO: 상세 구현 필요
  struct Payload {
    let orderCurrency: OrderCurrency
  }


  // MARK: Properties
  
  let coinDetailViewModel: CoinDetailViewModel
  let payload: Payload
  private let disposeBag: DisposeBag
  
  private let candleStickChartView: CandleStickChartView
  private let segmentedCategoryView: SegmentedCategoryView
  private let timeIntervalChangeButton: UIButton
  
  // MARK: Initializers

  init(payload: Payload) {
    self.payload = payload
    let categoryItems = ["호가", "차트"]
    self.segmentedCategoryView = SegmentedCategoryView(items: categoryItems, fontSize: 14)
    self.candleStickChartView = CandleStickChartView()
    self.timeIntervalChangeButton = UIButton()
    self.coinDetailViewModel = CoinDetailViewModel()
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
    self.bind()
  }
  
  private func layout() {
    [self.candleStickChartView,
     self.segmentedCategoryView,
     self.timeIntervalChangeButton].forEach { self.view.addSubview($0) }
    
    self.segmentedCategoryView.snp.makeConstraints {
      $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }
    
    self.candleStickChartView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(self.segmentedCategoryView.snp.bottom)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.timeIntervalChangeButton.snp.makeConstraints {
      $0.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
    }
  }
  
  private func attribute() {
    self.title = payload.orderCurrency.koreanName
    
    self.candleStickChartView.do {
      $0.noDataText = "데이터가 없습니다."
      $0.noDataFont = .systemFont(ofSize: 20)
      $0.noDataTextColor = .lightGray
      $0.backgroundColor = .white
      $0.xAxis.setLabelCount(3, force: false)
      $0.xAxis.labelPosition = .bottom
      $0.dragDecelerationEnabled = false
      $0.autoScaleMinMaxEnabled = true
      $0.doubleTapToZoomEnabled = false
      $0.highlightPerTapEnabled = false
      $0.rightAxis.enabled = false
      $0.leftAxis.enabled = true
      $0.scaleYEnabled = false
      $0.dragYEnabled = false
      $0.delegate = self
    }
    
    self.timeIntervalChangeButton.do {
      $0.setTitleColor(.black, for: .normal)
    }
  }
  
  private func bind() {
    self.timeIntervalChangeButton.rx.tap
      .bind(to: self.coinDetailViewModel.tapSelectTimeIntervalButton)
      .disposed(by: self.disposeBag)
    
    self.coinDetailViewModel.selectedTimeInterval
      .bind {
        self.timeIntervalChangeButton.setTitle($0.rawValue, for: .normal)
      }
      .disposed(by: self.disposeBag)
  }
  
  private func setChart(chartData: [ChartData]) {
    let dataEntries = self.convertToDataEntries(from: chartData)
    let axisValues = self.convertToAxisValues(from: chartData)
    
    let chartDataSet = CandleChartDataSet(entries: dataEntries).then {
      $0.shadowColorSameAsCandle = true
      $0.drawValuesEnabled = false
      $0.highlightEnabled = false
      $0.increasingFilled = true
      $0.decreasingFilled = true
      $0.increasingColor = .red
      $0.decreasingColor = .blue
    }
    
    let chartData = CandleChartData(dataSet: chartDataSet)
    let maxValue = self.candleStickChartView.chartXMax
    
    self.candleStickChartView.do {
      $0.data = chartData
      $0.xAxis.valueFormatter = IndexAxisValueFormatter(values: axisValues)
      $0.setVisibleXRangeMaximum(20.0)
      $0.moveViewToX(maxValue)
      $0.drawMarkers = false
    }
  }
  
  private func convertToDataEntries(from graphData: [ChartData]) -> [CandleChartDataEntry] {
    return graphData.enumerated().map {
      CandleChartDataEntry(x: Double($0),
                           shadowH: $1.highPrice,
                           shadowL: $1.lowPrice,
                           open: $1.openPrice,
                           close: $1.closePrice)
    }
  }
  
  private func convertToAxisValues(from graphData: [ChartData]) -> [String] {
    return graphData.map { $0.dateText }
  }
}

extension CoinDetailViewController: ChartViewDelegate {
  func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
    if chartView.maxVisibleCount == 20 {
      self.candleStickChartView.setVisibleXRange(minXRange: 10, maxXRange: 300)
    }
  }
}
