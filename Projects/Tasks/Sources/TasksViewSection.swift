//
//  TasksViewSection.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//
import RxDataSources_Texture

struct TasksViewSection: Equatable {
  enum Identity: String {
    case tasks
  }
  let identity: Identity
  var items: [Item]
}

extension TasksViewSection: AnimatableSectionModelType {
  init(original: TasksViewSection, items: [Item]) {
    self = TasksViewSection(identity: original.identity, items: items)
  }
}

extension TasksViewSection {
  enum Item: Hashable {
    case task(TaskItemReactor)
  }
}

extension TasksViewSection.Item: IdentifiableType {
  var identity: String {
    return "\(self.hashValue)"
  }
}

