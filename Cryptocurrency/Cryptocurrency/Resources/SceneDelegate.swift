//
//  SceneDelegate.swift
//  Bithumb
//
//  Created by Seungjin Baek on 2022/01/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    self.window = UIWindow(windowScene: windowScene)
    self.appCoordinator = AppCoordinator(window: self.window)

    self.appCoordinator?.start()
  }
}
