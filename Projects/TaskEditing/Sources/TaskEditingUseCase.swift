//
//  TaskEditingUseCase.swift
//  TaskEditing
//
//  Created by myunggison on 12/13/20.
//

import RxSwift
import RxRelay
import Common

public protocol TaskEditingUseCase {
  func createTask(title: String, memo: String) -> Single<Void>
  func editTask(taskId: String, title: String, memo: String) -> Single<Void>
  func presentCancelAlert() -> Observable<TaskEditingViewCancelAlertAction>
}

public class TaskEditingUseCaseImpl: TaskEditingUseCase {
  
  let taskRepository: TaskRepositoryProtocol
  let alertRepository: AlertRepositoryProtocol
  
  init(taskRepository: TaskRepositoryProtocol, alertRepository: AlertRepositoryProtocol) {
    self.taskRepository = taskRepository
    self.alertRepository = alertRepository
  }
  
  public func createTask(title: String, memo: String) -> Single<Void> {
    return self.taskRepository.create(title: title, memo: memo)
  }
  
  public func editTask(taskId: String, title: String, memo: String) -> Single<Void> {
    self.taskRepository.update(id: taskId, title: title, memo: memo)
  }
  
  public func presentCancelAlert() -> Observable<TaskEditingViewCancelAlertAction> {
    let alertActions: [TaskEditingViewCancelAlertAction] = [.leave, .stay]
    return self.alertRepository.show(
      title: "Really?",
      message: "All changes will be lost",
      preferredStyle: .alert,
      actions: alertActions
    )
  }
}

public enum TaskEditingViewCancelAlertAction: AlertActionType {
  case leave
  case stay
  
  public var title: String? {
    switch self {
    case .leave: return "Leave"
    case .stay: return "Stay"
    }
  }
  
  public var style: UIAlertAction.Style {
    switch self {
    case .leave: return .destructive
    case .stay: return .default
    }
  }
}
