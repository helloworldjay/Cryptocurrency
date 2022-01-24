//
//  SegmentedCategoryView.swift
//  Bithumb
//
//  Created by 김민성 on 2022/01/22.
//

import UIKit

import SnapKit
import Then

final class SegmentedCategoryView: UIView {
  
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
    self.setSegmentTitleTextAttributes(foregroundColor: .lightGray, for: .normal)
    self.setSegmentTitleTextAttributes(foregroundColor: .black, for: .selected)
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
  
  private func setSegmentTitleTextAttributes(foregroundColor: UIColor, for state: UIControl.State) {
    guard let font = UIFont(name: "AvenirNextCondensed-Medium", size: self.fontSize) else { return }
    self.segmentedControl.do {
      $0.setTitleTextAttributes([NSAttributedString.Key.font : font,
                                 NSAttributedString.Key.foregroundColor : foregroundColor],
                                for: state)
    }
  }
  
  @objc func changeIndex(_ sender: UISegmentedControl) {
    guard let titleForSegment = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
    let titlecount = CGFloat((titleForSegment.count))
    let selectedIndex = CGFloat(sender.selectedSegmentIndex)
    let numberOfSegments = CGFloat(sender.numberOfSegments)
    
    segmentIndicator.snp.remakeConstraints {
      $0.top.equalTo(self.segmentedControl.snp.bottom).offset(3)
      $0.height.equalTo(2)
      $0.width.equalTo(self.fontSize + titlecount * 8)
      $0.centerX.equalTo(self.segmentedControl.snp.centerX).dividedBy(numberOfSegments / CGFloat(3.0 + CGFloat(selectedIndex - 1.0) * 2.0))
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
      guard let titleForFirstSegment = self.segmentedControl.titleForSegment(at: 0) else { return }
      $0.top.equalTo(self.segmentedControl.snp.bottom).offset(3)
      $0.width.equalTo(Int(self.fontSize) + titleForFirstSegment.count * 8)
      $0.height.equalTo(2)
      $0.centerX.equalTo(self.segmentedControl.snp.centerX).dividedBy(self.segmentedControl.numberOfSegments)
    }
  }
}

