//
//  TaskItemReactor.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//

import ReactorKit
import RxSwift
import Common

public class TaskItemReactor: Reactor, IdentityHashable {
  
  public enum Action {
  }
  
  public enum Mutation {
  }
  
  public struct State {
    var title: String { self.task.title }
    var isMarked: Bool { self.task.isMarked }
    var id: String { self.task.id }
    fileprivate var task: Task
  }
  
  public var task: Task {
    return self.currentState.task
  }
  
  public let initialState: State
  
  public init(task: Task) {
    self.initialState = State(task: task)
  }
}
