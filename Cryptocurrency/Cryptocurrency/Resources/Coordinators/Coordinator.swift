//
//  Coordinator.swift
//  Cryptocurrency
//
//  Created by Seungjin Baek on 2022/01/28.
//

import Foundation

protocol Coordinator : AnyObject {
  var childCoordinators: [Coordinator] { get set }
  
  func start()
}
