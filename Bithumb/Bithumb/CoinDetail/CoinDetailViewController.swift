//
//  CoinDetailViewController.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/28.
//

import UIKit

final class CoinDetailViewController: UIViewController {

  // TODO: 상세 구현 필요
  struct Payload {
    let orderCurrency: OrderCurrency
  }


  // MARK: Properties

  let payload: Payload


  // MARK: Initializers

  init(payload: Payload) {
    self.payload = payload
    super.init(nibName: nil, bundle: nil)
    // FIXME: 값 넘김 확인을 위한 타이틀로 상세 구현시 삭제 필요
    self.title = payload.orderCurrency.koreanName
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
