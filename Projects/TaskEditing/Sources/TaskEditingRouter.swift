//
//  TaskEditingRouter.swift
//  TaskEditing
//
//  Created by myunggison on 12/13/20.
//

import RIBs
import Common

public protocol TaskEditingInteractable: Interactable {
  var router: TaskEditingRouting? { get set }
  var listener: TaskEditingListener? { get set }
}

public protocol TaskEditingViewControllable: ViewControllable {
}

public final class TaskEditingRouter
: ViewableRouter<TaskEditingInteractable, TaskEditingViewControllable>
, TaskEditingRouting
, DITaskEditingRouting {
  
  public override init(interactor: TaskEditingInteractable, viewController: TaskEditingViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
