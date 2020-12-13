//
//  Pushable.swift
//  Common
//
//  Created by myunggison on 12/14/20.
//

import UIKit
import RIBs

public protocol Pushable: class {
  func push(viewController: ViewControllable, animated: Bool)
}

public extension Pushable where Self: UIViewController {
  func push(viewController: ViewControllable, animated: Bool) {
    self.navigationController?.pushViewController(viewController.uiviewController, animated: animated)
  }
}

public extension Pushable where Self: UINavigationController {
  func push(viewController: ViewControllable, animated: Bool) {
    self.pushViewController(viewController.uiviewController, animated: animated)
  }
}
