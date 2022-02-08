//
//  PaddingLabel.swift
//  Cryptocurrency
//
//  Created by 이영우 on 2022/02/07.
//

import UIKit

class PaddingLabel: UILabel {
  
  // MARK: Properties
  
  var padding: UIEdgeInsets
  
  
  // MARK: Initializer
  
  init(padding: UIEdgeInsets) {
    self.padding = padding
    
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.height += padding.top + padding.bottom
    contentSize.width += padding.left + padding.right
    return contentSize
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }
}
