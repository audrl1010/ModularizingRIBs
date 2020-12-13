//
//  TasksBuilder.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//

import RIBs
import Common

public protocol TasksDependency: Dependency {
}

public final class TasksComponent: Component<TasksDependency> {
  var useCase: TasksUseCase {
    TasksUseCaseImpl(
      taskRepository: repositoryResolve(TaskRepositoryProtocol.self)
    )
  }
}

public protocol TasksBuildable: Buildable {
  func build(withListener listener: TasksListener) -> TasksRouting
}

public final class TasksBuilder
  : Builder<TasksDependency>
  , TasksBuildable {
  
  public override init(dependency: TasksDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: TasksListener) -> TasksRouting {
    let component = TasksComponent(dependency: dependency)
    let listAdapter = TasksListAdapter()
    let viewController = TasksViewController(listAdapter: listAdapter)
    listAdapter.viewController = viewController
    let interactor = TasksInteractor(presenter: viewController, useCase: component.useCase)
    interactor.listener = listener
    
    let taskEditingBuilder = ribsDIContainer.resolve(DITaskEditingBuildable.self, argument: component as DITaskEditingDependency)!
    
    return TasksRouter(
      interactor: interactor,
      viewController: viewController,
      taskEditingBuilder: taskEditingBuilder
    )
  }
}
