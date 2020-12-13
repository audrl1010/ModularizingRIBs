//
//  RootRouter.swift
//  App
//
//  Created by myunggison on 12/12/20.
//

import RIBs
import Common

protocol RootInteractable
: Interactable
, DITasksListener {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable, ReplaceChild {
}

final class RootRouter
  : LaunchRouter<RootInteractable, RootViewControllable>
  , RootRouting {
  
  let tasksBuilder: DITasksBuildable
  var tasks: DITasksRouting?
  
  init(
    interactor: RootInteractable,
    viewController: RootViewControllable,
    tasksBuilder: DITasksBuildable
  ) {
    self.tasksBuilder = tasksBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func routeToTask() {
    let tasks = self.tasksBuilder.build(withListener: self.interactor)
    self.tasks = tasks
    self.attachChild(tasks)
    let navigationController = UINavigationController(
      root: tasks.viewControllable
    )
    self.viewController.replaceChild(viewController: navigationController, animated: false)
  }
  
  func detachTaskEditing() {
    if let tasks = self.tasks {
      self.detachChild(tasks)
      self.tasks = nil
      self.viewController.replaceChild(viewController: nil, animated: false)
    }
  }
}
