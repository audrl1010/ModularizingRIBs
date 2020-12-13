//
//  TaskEditingBuilder.swift
//  TaskEditing
//
//  Created by myunggison on 12/13/20.
//

import RIBs
import Common

public protocol TaskEditingDependency: Dependency {
}

public final class TaskEditingComponent: Component<TaskEditingDependency> {
  var useCase: TaskEditingUseCase {
    TaskEditingUseCaseImpl(
      taskRepository: repositoryResolve(TaskRepositoryProtocol.self),
      alertRepository: repositoryResolve(AlertRepositoryProtocol.self)
    )
  }
}

// MARK: - Builder

public protocol TaskEditingBuildable: Buildable {
  func build(withListener listener: TaskEditingListener, mode: TaskEditingViewMode) -> TaskEditingRouting
}

public final class TaskEditingBuilder: Builder<TaskEditingDependency>, TaskEditingBuildable {
  
  public override init(dependency: TaskEditingDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: TaskEditingListener, mode: TaskEditingViewMode) -> TaskEditingRouting {
    let component = TaskEditingComponent(dependency: dependency)
    let viewController = TaskEditingViewController()
    let interactor = TaskEditingInteractor(presenter: viewController, useCase: component.useCase, mode: mode)
    interactor.listener = listener
    return TaskEditingRouter(interactor: interactor, viewController: viewController)
  }
}
