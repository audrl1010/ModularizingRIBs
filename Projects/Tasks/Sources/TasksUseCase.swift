//
//  TasksUseCase.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//

import RxSwift
import RxRelay
import Common

public protocol TasksUseCase {
  func moveTask(sourceTaskId: String, destinationPosition: Int) -> Single<Void>
  func tasks() -> Single<[Task]>
  func deleteTask(taskId: String) -> Single<Void>
  func toggleTask(task: Task) -> Single<Void>
  func taskEvent() -> Observable<TaskEvent>
}

public class TasksUseCaseImpl: TasksUseCase {
  
  private let taskRepository: TaskRepositoryProtocol
  
  public init(
    taskRepository: TaskRepositoryProtocol
  ) {
    self.taskRepository = taskRepository
  }
  
  public func deleteTask(taskId: String) -> Single<Void> {
    return self.taskRepository.delete(id: taskId)
  }
  
  public func toggleTask(task: Task) -> Single<Void> {
    return !task.isMarked
      ? self.taskRepository.mark(id: task.id)
      : self.taskRepository.unmark(id: task.id)
  }
  
  public func moveTask(sourceTaskId: String, destinationPosition: Int) -> Single<Void> {
    return self.taskRepository.move(id: sourceTaskId, destinationIndex: destinationPosition)
  }
  
  public func tasks() -> Single<[Task]> {
    return self.taskRepository.tasks()
  }
  
  public func taskEvent() -> Observable<TaskEvent> {
    return self.taskRepository.event.asObservable()
  }
}
