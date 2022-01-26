//
//  UISegmentedControl + Ext.swift
//  Bithumb
//
//  Created by 김민성 on 2022/01/23.
//

import UIKit

extension UISegmentedControl {
  func setDividerColor(with color: UIColor) {
    setDividerImage(
      color.image(CGSize(width: 0.1, height: 0.1)),
      forLeftSegmentState: .normal,
      rightSegmentState: .normal,
      barMetrics: .default
    )
  }
}
