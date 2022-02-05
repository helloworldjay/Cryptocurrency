//
//  CoinChartView.swift
//  Bithumb
//
//  Created by 이영우 on 2022/02/05.
//

import Charts
import RxSwift
import Then

final class CoinChartView: CandleStickChartView {
  
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  private var isUpdated = false
  
  
  // MARK: Initializer
  
  init() {
    super.init(frame: .zero)
    
    self.attribute()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {
    self.do {
      $0.noDataText = "데이터가 없습니다."
      $0.noDataFont = .systemFont(ofSize: 20)
      $0.noDataTextColor = .lightGray
      $0.backgroundColor = .white
      $0.xAxis.setLabelCount(4, force: false)
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
  }
  
  func bind(viewModel: CoinChartViewModelLogic) {
    viewModel.chartData
      .bind { chartData in
        self.setChart(chartData: chartData)
        self.isUpdated = true
      }.disposed(by: self.disposeBag)
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
      $0.label = nil
      $0.form = .none
    }
    
    let chartData = CandleChartData(dataSet: chartDataSet)

    self.do {
      $0.data = chartData
      $0.xAxis.valueFormatter = IndexAxisValueFormatter(values: axisValues)
      $0.setVisibleXRangeMaximum(20.0)
      $0.moveViewToX($0.chartXMax)
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


// MARK: Delegate

extension CoinChartView: ChartViewDelegate {
  func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
    if self.isUpdated == true {
      self.setVisibleXRange(minXRange: 10, maxXRange: 300)
      self.isUpdated = false
    }
  }
}
