//
//  ReplaceChild.swift
//  Common
//
//  Created by myunggison on 12/14/20.
//

import RIBs
import UIKit
import SnapKit

public protocol ReplaceChild: class {
  var targetChildController: ViewControllable? { get set }
  func replaceChild(viewController: ViewControllable?, animated: Bool)
  func setConstraints(_ parentView: UIView, childView: UIView)
}

public extension ReplaceChild where Self: UIViewController {
  func setConstraints(_ parentView: UIView, childView: UIView) {
    childView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func add(_ child: UIViewController) {
    self.addChild(child)
    self.view.addSubview(child.view)
    self.setConstraints(self.view, childView: child.view)
    child.didMove(toParent: self)
  }
  
  private func remove(_ child: UIViewController) {
    self.willMove(toParent: nil)
    child.view.removeFromSuperview()
    child.removeFromParent()
  }
  
  func replaceChild(viewController: ViewControllable?, animated: Bool = false) {
    let oldViewController = self.targetChildController?.uiviewController
    
    if animated {
      UIView.animate(
        withDuration: 0.05,
        animations: {
          oldViewController?.view.alpha = 0.0
          viewController?.uiviewController.view.alpha = 1.0
        },
        completion: { _ in
          defer {
            if let oldViewController = oldViewController {
              self.remove(oldViewController)
            }
          }
          self.targetChildController = viewController
          if let viewController = viewController?.uiviewController {
            self.add(viewController)
          }
        }
      )
    } else {
      defer {
        if let oldViewController = oldViewController {
          self.remove(oldViewController)
        }
      }
      self.targetChildController = viewController
      if let viewController = viewController?.uiviewController {
        self.add(viewController)
      }
    }
  }
}
