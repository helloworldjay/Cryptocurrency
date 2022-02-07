//
//  SegmentedCategoryView.swift
//  Bithumb
//
//  Created by 김민성 on 2022/01/22.
//

import UIKit

import SnapKit
import Then

class SegmentedCategoryView: UIView {

  // MARK: Properties
  
  var segmentedControl: UISegmentedControl
  private let segmentIndicator = UIView().then {
    $0.backgroundColor = .signature
  }
  private var fontSize: CGFloat


  // MARK: Initializers
  
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
    self.segmentIndicator.snp.remakeConstraints {
      self.setSegmentIndicatorConstraints(of: $0, remake: true)
    }

    UIView.animate(
      withDuration: 0.2,
      animations: { self.layoutIfNeeded() }
    )
  }
  
  private func setSegmentIndicatorConstraints(of make: ConstraintMaker, remake: Bool) {
    let selectedIndex = CGFloat(self.segmentedControl.selectedSegmentIndex)
    let numberOfSegments = CGFloat(self.segmentedControl.numberOfSegments)
    let segmentedControlWidth = CGFloat(self.segmentedControl.frame.width)
    let segmentWidth = segmentedControlWidth / numberOfSegments
    let headerWidth = 0.1 * segmentWidth
    let dividerWidth = 0.1
    let leadingInset = remake ? segmentWidth * selectedIndex + headerWidth + dividerWidth * selectedIndex : headerWidth
    
    make.top.equalTo(self.segmentedControl.snp.bottom).offset(3)
    make.leading.equalTo(self.segmentedControl.snp.leading).inset(leadingInset)
    make.width.equalTo(segmentedControl.snp.width).dividedBy(numberOfSegments / 0.8)
    make.height.equalTo(2)
  }
  
  private func layout() {
    [self.segmentedControl, self.segmentIndicator].forEach {
      self.addSubview($0)
    }
    
    self.snp.makeConstraints {
      $0.edges.equalTo(self.segmentedControl.snp.edges)
    }
    
    self.segmentIndicator.snp.makeConstraints {
      self.setSegmentIndicatorConstraints(of: $0, remake: false)
    }
  }
}
