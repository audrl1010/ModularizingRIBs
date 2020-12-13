//
//  SceneDelegate.swift
//  TaskEditingAppEnvironment
//
//
import UIKit
import Tasks
import RIBs
import Common

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var router: TasksRouting?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }

    self.window = UIWindow(windowScene: scene)
    self.window?.makeKeyAndVisible()
  }
}
