//
//  RootViewController.swift
//  App
//
//  Created by myunggison on 12/12/20.
//

import RIBs
import UIKit

protocol RootPresentableListener: class {
}

final class RootViewController
  : UIViewController
  , RootPresentable
  , RootViewControllable {
  
  var targetChildController: ViewControllable?

  weak var listener: RootPresentableListener?
}
