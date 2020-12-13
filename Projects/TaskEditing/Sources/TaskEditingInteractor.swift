//
//  TaskEditingInteractor.swift
//  TaskEditing
//
//  Created by myunggison on 12/13/20.
//

import RIBs
import RxSwift
import ReactorKit
import Common

public enum TaskEditingViewMode {
  case new
  case edit(Task)
}

public protocol TaskEditingRouting: DITaskEditingRouting {
}

public protocol TaskEditingPresentable: Presentable {
  var listener: TaskEditingPresentableListener? { get set }
}

public protocol TaskEditingListener: class {
  func taskEditingDidFinish()
}

public struct TaskEditingViewState {
  var title: String
  var taskTitle: String
  var canSubmit: Bool
  var shouldConfirmCancel: Bool

  init(title: String, taskTitle: String, canSubmit: Bool) {
    self.title = title
    self.taskTitle = taskTitle
    self.canSubmit = canSubmit
    self.shouldConfirmCancel = false
  }
}

public final class TaskEditingInteractor
: PresentableInteractor<TaskEditingPresentable>
, TaskEditingInteractable
, TaskEditingPresentableListener
, Reactor {
  
  public typealias State = TaskEditingViewState
  public typealias Action = TaskEditingViewAction
  
  public enum Mutation {
    case updateTaskTitle(String)
  }
  
  public weak var router: TaskEditingRouting?
  public weak var listener: TaskEditingListener?

  private let mode: TaskEditingViewMode
  private let useCase: TaskEditingUseCase
  
  public let initialState: State
  
  init(presenter: TaskEditingPresentable, useCase: TaskEditingUseCase, mode: TaskEditingViewMode) {
    self.mode = mode
    self.useCase = useCase

    switch mode {
    case .new:
      self.initialState = State(
        title: "New",
        taskTitle: "",
        canSubmit: false
      )
    case .edit(let task):
      self.initialState = State(
        title: "Edit",
        taskTitle: task.title,
        canSubmit: true
      )
    }
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  public override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  public override func willResignActive() {
    super.willResignActive()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .updateTaskTitle(taskTitle):
      return .just(.updateTaskTitle(taskTitle))
      
    case .submit:
      guard self.currentState.canSubmit else { return .empty() }
      return self.submitMutation(mode: mode)
      
    case .cancel:
      return self.cancelMutation()
    }
  }
  
  private func submitMutation(mode: TaskEditingViewMode) -> Observable<Mutation> {
    switch self.mode {
    case .new:
      return self.newMutation()
      
    case let .edit(task):
      return editMutation(task: task)
    }
  }
  
  private func newMutation() -> Observable<Mutation> {
    return self.useCase.createTask(title: self.currentState.taskTitle, memo: "").asObservable()
      .observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] _ in
        self?.listener?.taskEditingDidFinish()
      })
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func editMutation(task: Task) -> Observable<Mutation> {
    return self.useCase.editTask(taskId: task.id, title: self.currentState.taskTitle, memo: "").asObservable()
      .observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] _ in self?.listener?.taskEditingDidFinish() })
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func cancelMutation() -> Observable<Mutation> {
    if !self.currentState.shouldConfirmCancel {
      return Observable.just(())
      .observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] _ in self?.listener?.taskEditingDidFinish() })
      .flatMap { _ -> Observable<Mutation> in .empty() }
    }
    
    return self.useCase.presentCancelAlert()
      .observeOn(MainScheduler.instance)
      .do(onNext: { alertAction in
        switch alertAction {
        case .leave: self.listener?.taskEditingDidFinish()
        case .stay: break
        }
      })
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .updateTaskTitle(taskTitle):
      newState.taskTitle = taskTitle
      newState.canSubmit = !taskTitle.isEmpty
      newState.shouldConfirmCancel = taskTitle != self.initialState.taskTitle
      return newState
    }
  }
}

