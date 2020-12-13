//
//  TasksRouter.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//

import RIBs
import Common

protocol TasksInteractable
: Interactable
, DITaskEditingListener {
  var router: TasksRouting? { get set }
  var listener: TasksListener? { get set }
}

protocol TasksViewControllable: ViewControllable, Pushable, Popable {
}

final class TasksRouter
  : ViewableRouter<TasksInteractable, TasksViewControllable>
  , TasksRouting {
  
  let taskEditingBuilder: DITaskEditingBuildable
  var taskEditing: DITaskEditingRouting?
  
  init(
    interactor: TasksInteractable,
    viewController: TasksViewControllable,
    taskEditingBuilder: DITaskEditingBuildable
  ) {
    self.taskEditingBuilder = taskEditingBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func routeToTaskEditing(mode: DITaskEditingViewMode) {
    let taskEditing = self.taskEditingBuilder.build(withListener: self.interactor, mode: mode)
    self.taskEditing = taskEditing
    self.attachChild(taskEditing)
    self.viewController.push(viewController: taskEditing.viewControllable, animated: true)
  }
  
  func detachTaskEditing() {
    if let taskEditing = self.taskEditing {
      self.detachChild(taskEditing)
      self.taskEditing = nil
      self.viewController.pop(animated: true)
    }
  }
}
