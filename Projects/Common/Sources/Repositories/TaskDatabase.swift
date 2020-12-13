//
//  TaskDatabase.swift
//  Common
//
//  Created by myunggison on 12/12/20.
//

import RxSwift
import RxRelay
import RealmSwift
import RxRealm

public protocol TaskDatabaseProtocol {
  func create(title: String, memo: String) -> Single<Task>
  func tasks() -> Single<[Task]>
  func delete(id: String) -> Single<Task>
  func mark(id: String) -> Single<Task>
  func unmark(id: String) -> Single<Task>
  func move(id: String, destinationIndex: Int) -> Single<Task>
  func update(id: String, title: String, memo: String) -> Single<Task>
}

public enum TaskRealmDatabaseError: Error {
  case notFound
  case failedToInsert
}

public class TaskRealmDatabase: TaskDatabaseProtocol {
  
  private let realm: Realm
  
  public init() {
    self.realm = try! Realm()
    if self.realm.isEmpty {
      try! realm.write {
        realm.add(RMTaskList())
      }
    }
  }
  
  public func create(title: String, memo: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first
      else {
        observer(.error(TaskRealmDatabaseError.notFound))
        return Disposables.create()
      }
      
      let task = RMTask(title: title, memo: memo)
      
      do {
        try self.realm.write {
          taskList.tasks.insert(task, at: 0)
        }
      } catch let error {
        observer(.error(error))
      }
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  public func tasks() -> Single<[Task]> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first
      else {
        observer(.error(TaskRealmDatabaseError.notFound))
        return Disposables.create()
      }
      observer(.success(Array(taskList.tasks.map(Task.init))))
      return Disposables.create()
    }
  }
  
  public func delete(id: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let task = taskList.tasks.filter("id = %@", id).first,
        let taskIndex = taskList.tasks.firstIndex(of: task)
      else {
        observer(.error(TaskRealmDatabaseError.notFound))
        return Disposables.create()
      }
      
      do {
        try self.realm.write {
          taskList.tasks.remove(at: taskIndex)
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  public func mark(id: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let task = taskList.tasks.filter("id = %@", id).first
      else {
        observer(.error(TaskRealmDatabaseError.notFound))
        return Disposables.create()
      }
      
      do {
        try self.realm.write {
          task.isMarked = true
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  public func unmark(id: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let task = taskList.tasks.filter("id = %@", id).first
      else {
        observer(.error(TaskRealmDatabaseError.notFound))
        return Disposables.create()
      }
      
      do {
        try self.realm.write {
          task.isMarked = false
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  public func move(id: String, destinationIndex: Int) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let sourceTask = taskList.tasks.filter("id = %@", id).first,
        let sourceTaskIndex = taskList.tasks.firstIndex(of: sourceTask)
      else {
        observer(.error(TaskRealmDatabaseError.notFound))
        return Disposables.create()
      }
      
      let task = taskList.tasks[sourceTaskIndex]
      
      do {
        try self.realm.write {
          taskList.tasks.remove(at: sourceTaskIndex)
          taskList.tasks.insert(task, at: destinationIndex)
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  public func update(id: String, title: String, memo: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let task = taskList.tasks.filter("id = %@", id).first
      else {
        observer(.error(TaskRealmDatabaseError.notFound))
        return Disposables.create()
      }
      
      do {
        try self.realm.write {
          task.title = title
          task.memo = memo
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
}
