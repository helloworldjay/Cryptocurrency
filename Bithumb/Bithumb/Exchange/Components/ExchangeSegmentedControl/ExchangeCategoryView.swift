//
//  ExchangeSegmentedControl.swift
//  Bithumb
//
//  Created by 김민성 on 2022/01/22.
//

import UIKit

import SnapKit
import Then

final class ExchangeCategoryView: UIView {
  
  //MARK: Properties
  
  var segmentedControl: UISegmentedControl
  private let segmentIndicator = UIView()
  
  private var fontSize: CGFloat
  
  
  //MARK: Initializers
  
  init(items: [String] = [], fontSize: CGFloat) {
    self.segmentedControl = UISegmentedControl(items: items)
    self.fontSize = fontSize
    super.init(frame: .zero)
    self.attribute()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func attribute() {
    self.setTitleTextAttributes(foregroundColor: .lightGray, for: .normal)
    self.setTitleTextAttributes(foregroundColor: .black, for: .selected)
    self.segmentedControl.do {
      $0.setDividerColor(with: .white)
      $0.selectedSegmentIndex = 0
      $0.addTarget(self, action: #selector(changeIndex), for: .valueChanged)
      $0.subviews.forEach {
        $0.backgroundColor = .white
      }
    }
    
    self.segmentIndicator.do {
      $0.backgroundColor = .bithumb
    }
  }
  
  private func setTitleTextAttributes(foregroundColor: UIColor, for state: UIControl.State) {
    guard let font = UIFont(name: "AvenirNextCondensed-Medium", size: self.fontSize) else { return }
    self.segmentedControl.do {
      $0.setTitleTextAttributes([NSAttributedString.Key.font : font,
                                 NSAttributedString.Key.foregroundColor : foregroundColor],
                                for: state)
    }
  }
  
  @objc func changeIndex(_ sender: UISegmentedControl) {
    let numberOfSegments = CGFloat(self.segmentedControl.numberOfSegments)
    let selectedIndex = CGFloat(sender.selectedSegmentIndex)
    let titlecount = CGFloat((self.segmentedControl.titleForSegment(at: sender.selectedSegmentIndex)!.count))
    
    segmentIndicator.snp.remakeConstraints {
      $0.top.equalTo(self.segmentedControl.snp.bottom).offset(3)
      $0.height.equalTo(2)
      $0.width.equalTo(self.fontSize + titlecount * 8)
      $0.centerX.equalTo(self.segmentedControl.snp.centerX).dividedBy(numberOfSegments / CGFloat(3.0 + CGFloat(selectedIndex-1.0)*2.0))
    }
  }
  
  private func layout() {
    [self.segmentedControl, self.segmentIndicator].forEach {
      self.addSubview($0)
    }
    
    self.snp.makeConstraints {
      $0.edges.equalTo(self.segmentedControl.snp.edges)
    }
    
    self.segmentIndicator.snp.makeConstraints {
      $0.top.equalTo(self.segmentedControl.snp.bottom).offset(3)
      $0.height.equalTo(2)
      $0.width.equalTo(Int(self.fontSize) + self.segmentedControl.titleForSegment(at: 0)!.count * 8)
      $0.centerX.equalTo(self.segmentedControl.snp.centerX).dividedBy(self.segmentedControl.numberOfSegments)
    }
  }
}

