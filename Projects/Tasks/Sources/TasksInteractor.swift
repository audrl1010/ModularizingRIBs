//
//  TasksInteractor.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//
import RIBs
import RxSwift
import ReactorKit
import Common

public protocol TasksRouting: DITasksRouting {
  func routeToTaskEditing(mode: DITaskEditingViewMode)
  func detachTaskEditing()
}

public protocol TasksPresentable: Presentable {
  var listener: TasksPresentableListener? { get set }
}

public protocol TasksListener: class {
}

public struct TasksViewState {
  var sections: [TasksViewSection] = []
  
  var isLoading: Bool = false
  var isEditing: Bool = false
  
  fileprivate var tasks: [Task] = []
}

public final class TasksInteractor
  : PresentableInteractor<TasksPresentable>
  , TasksInteractable
  , TasksPresentableListener
  , Reactor {
  
  public typealias State = TasksViewState
  public typealias Action = TasksViewAction

  public enum Mutation {
    case setLoading(Bool)
    case setTasks([Task])
    case toggleEditing
    case createTask(Task)
    case deleteTask(index: Int)
    case updateTask(index: Int, Task)
    case moveTask(from: Int, to: Int)
  }
  
  let scheduler = MainScheduler.asyncInstance
  
  weak var router: TasksRouting?
  weak var listener: TasksListener?
  
  public let initialState: State
  
  private let useCase: TasksUseCase

  init(presenter: TasksPresentable, useCase: TasksUseCase) {
    defer { _ = self.state }
    self.useCase = useCase
    self.initialState = State()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  public override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  public override func willResignActive() {
    super.willResignActive()
  }
  
  public func mutate(action: TasksViewAction) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return self.refreshMutation()
      
    case .toggleEditing:
      return .just(.toggleEditing)
      
    case let .toggleTaskDone(indexPath):
      return self.toggleTaskDoneMutation(indexPath: indexPath)
      
    case let .deleteTask(indexPath):
      return self.deleteTaskMutation(indexPath: indexPath)
      
    case let .moveTask(sourceIndexPath, destinationIndexPath):
      return self.moveTask(
        sourceIndexPath: sourceIndexPath,
        destinationIndexPath: destinationIndexPath
      )
    case .addTask:
      return self.addTaskMutation()
      
    case let .editTask(indexPath):
      return self.editTaskMutation(indexPath: indexPath)
    }
  }
  
  private func editTaskMutation(indexPath: IndexPath) -> Observable<Mutation> {
    let task = self.currentState.tasks[indexPath.item]
    return Observable.just(task)
    .observeOn(MainScheduler.instance)
    .do(onNext: { [weak self] task in
      self?.router?.routeToTaskEditing(mode: .edit(task))
    })
    .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func addTaskMutation() -> Observable<Mutation> {
    return Observable.just(Void())
      .observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] _ in self?.router?.routeToTaskEditing(mode: .new) })
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func deleteTaskMutation(indexPath: IndexPath) -> Observable<Mutation> {
    let task = self.currentState.tasks[indexPath.item]
    return self.useCase.deleteTask(taskId: task.id).asObservable()
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func toggleTaskDoneMutation(indexPath: IndexPath) -> Observable<Mutation> {
    let task = self.currentState.tasks[indexPath.item]
    return self.useCase.toggleTask(task: task).asObservable()
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  func moveTask(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) -> Observable<Mutation> {
    let task = self.currentState.tasks[sourceIndexPath.item]
    return self.useCase.moveTask(sourceTaskId: task.id, destinationPosition: destinationIndexPath.item).asObservable()
    .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func refreshMutation() -> Observable<Mutation> {
    let tasks = self.useCase.tasks().asObservable()
      .map(Mutation.setTasks)
      .catchError { _ in .empty() }
    
    return Observable.concat([
      Observable.just(.setLoading(true)),
      tasks,
      Observable.just(.setLoading(false))
    ])
  }
  
  public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, self.taskEventMutation())
  }
  
  private func taskEventMutation() -> Observable<Mutation> {
    return self.useCase.taskEvent().flatMap { [weak self] event -> Observable<Mutation> in
      guard let self = self else { return .empty() }
      let state = self.currentState
      switch event {
      case let .delete(id):
        let index = state.tasks.firstIndex { task in task.id == id }
        if let index = index {
          return .just(Mutation.deleteTask(index: index))
        } else  {
          return .empty()
        }
        
      case let .move(id, destinationIndex):
        let sourceIndex = state.tasks.firstIndex { task in task.id == id }
        if let sourceIndex = sourceIndex {
          return .just(.moveTask(from: sourceIndex, to: destinationIndex))
        } else {
          return .empty()
        }
        
      case let .create(task):
        return .just(Mutation.createTask(task))
        
      case let .mark(id):
        let index = state.tasks.firstIndex { task in task.id == id }
        if let index = index {
          var task = state.tasks[index]
          task.isMarked = true
          return .just(Mutation.updateTask(index: index, task))
        } else {
          return .empty()
        }
        
      case let .unmark(id):
        let index = state.tasks.firstIndex { task in task.id == id }
        if let index = index {
          var task = state.tasks[index]
          task.isMarked = false
          return .just(Mutation.updateTask(index: index, task))
        } else {
          return .empty()
        }
        
      case let .update(task):
        let taskId = task.id
        let index = state.tasks.firstIndex { task in task.id == taskId }
        if let index = index {
          return .just(Mutation.updateTask(index: index, task))
        } else {
          return .empty()
        }
      }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
      
    case let .setTasks(tasks):
      newState.tasks = tasks
      newState.sections = [
        TasksViewSection(
          identity: .tasks,
          items: tasks
            .map(TaskItemReactor.init)
            .map(TasksViewSection.Item.task))
      ]
      
    case .toggleEditing:
      newState.isEditing = !newState.isEditing
      
    case let .createTask(task):
      newState.tasks.insert(task, at: 0)
      let sectionItem: TasksViewSection.Item = .task(TaskItemReactor(task: task))
      newState.sections[0].items.insert(sectionItem, at: 0)
      
    case let .deleteTask(index):
      newState.tasks.remove(at: index)
      newState.sections[0].items.remove(at: index)
      
    case let .updateTask(index, task):
      newState.tasks[index] = task
      newState.sections[0].items[index] = .task(TaskItemReactor(task: task))
      
    case let .moveTask(from, to):
      let task = newState.tasks.remove(at: from)
      newState.tasks.insert(task, at: to)
      
      newState.sections[0].items.remove(at: from)
      let sectionItem: TasksViewSection.Item = .task(TaskItemReactor(task: task))
      newState.sections[0].items.insert(sectionItem, at: to)
    }
    
    return newState
  }
}

// MARK: TaskEditingListener

extension TasksInteractor {
  
  public func taskEditingDidFinish() {
    self.router?.detachTaskEditing()
  }
}
