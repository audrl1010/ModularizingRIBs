//
//  ViewControllerable+Extensions.swift
//  Common
//
//  Created by myunggison on 12/14/20.
//

import RIBs
import UIKit

extension UINavigationController: ViewControllable {
  public var uiviewController: UIViewController {
    return self
  }
  
  public convenience init(root: ViewControllable) {
    self.init(rootViewController: root.uiviewController)
  }
}
