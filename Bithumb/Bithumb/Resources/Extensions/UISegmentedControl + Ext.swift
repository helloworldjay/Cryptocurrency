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
      imageWithColor(color: color),
      forLeftSegmentState: .normal,
      rightSegmentState: .normal,
      barMetrics: .default
    )
  }

  private func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}
