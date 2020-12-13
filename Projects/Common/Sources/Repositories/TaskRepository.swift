//
//  TaskRepository.swift
//  Common
//
//  Created by myunggison on 12/12/20.
//

import RxSwift
import RxRelay
import RealmSwift
import RxRealm

public enum TaskEvent {
  case update(Task)
  case create(Task)
  case delete(id: String)
  case move(id: String, destinationIndex: Int)
  case mark(id: String)
  case unmark(id: String)
}

public protocol TaskRepositoryProtocol {
  
  var event: PublishRelay<TaskEvent> { get }
  
  func update(id: String, title: String, memo: String) -> Single<Void>
  func create(title: String, memo: String) -> Single<Void>
  func delete(id: String) -> Single<Void>
  func tasks() -> Single<[Task]>
  func mark(id: String) -> Single<Void>
  func unmark(id: String) -> Single<Void>
  func move(id: String, destinationIndex: Int) -> Single<Void>
}

public class TaskRepositoryImpl: TaskRepositoryProtocol {
  
  public var event: PublishRelay<TaskEvent> = .init()
  
  private let database: TaskDatabaseProtocol
  
  public init(database: TaskDatabaseProtocol) {
    self.database = database
  }
  
  public func delete(id: String) -> Single<Void> {
    return self.database.delete(id: id)
      .do(onSuccess: { task in
        self.event.accept(TaskEvent.delete(id: task.id))
      })
      .map { _ in }
  }
  
  public func create(title: String, memo: String) -> Single<Void> {
    return self.database.create(title: title, memo: memo)
      .do(onSuccess: { task in
        self.event.accept(TaskEvent.create(task))
      })
      .map { _ in }
  }
  
  public func tasks() -> Single<[Task]> {
    return self.database.tasks()
  }
  
  public func mark(id: String) -> Single<Void> {
    return self.database.mark(id: id)
    .do(onSuccess: { task in
      self.event.accept(TaskEvent.mark(id: id))
    })
    .map { _ in }
  }
  
  public func unmark(id: String) -> Single<Void> {
    return self.database.unmark(id: id)
    .do(onSuccess: { task in
      self.event.accept(TaskEvent.unmark(id: id))
    })
    .map { _ in }
  }
  
  public func move(id: String, destinationIndex: Int) -> Single<Void> {
    return self.database.move(id: id, destinationIndex: destinationIndex)
    .do(onSuccess: { task in
      self.event.accept(TaskEvent.move(id: task.id, destinationIndex: destinationIndex))
    })
    .map { _ in }
  }
  
  public func update(id: String, title: String, memo: String) -> Single<Void> {
    return self.database.update(id: id, title: title, memo: memo)
    .do(onSuccess: { task in
      self.event.accept(TaskEvent.update(task))
    })
    .map { _ in }
  }
}
