//
//  Popable.swift
//  Common
//
//  Created by myunggison on 12/14/20.
//

import UIKit
import RIBs

public protocol Popable: class {
  func pop(animated: Bool)
  func popRoot(animated: Bool)
  func popToViewController(viewController: ViewControllable, animated: Bool)
}

public extension Popable where Self: UIViewController {
  func pop(animated: Bool = true) {
    self.navigationController?.popViewController(animated: animated)
  }
  
  func popRoot(animated: Bool = true) {
    self.navigationController?.popToRootViewController(animated: animated)
  }
  
  func popToViewController(viewController: ViewControllable, animated: Bool) {
    self.navigationController?.popToViewController(viewController.uiviewController, animated: animated)
  }
}

public extension Popable where Self: UINavigationController {
  func pop(animated: Bool = true) {
    self.popViewController(animated: animated)
  }
  
  func popRoot(animated: Bool = true) {
    self.popToRootViewController(animated: animated)
  }
  
  func popToViewController(viewController: ViewControllable, animated: Bool) {
    self.popToViewController(viewController.uiviewController, animated: animated)
  }
}
