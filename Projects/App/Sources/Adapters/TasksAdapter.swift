//
//  TasksAdapter.swift
//  App
//
//  Created by myunggison on 12/13/20.
//

import RIBs
import Common
import TaskEditing

public class DITaskEditingBuilerAdapter
: Builder<DITaskEditingDependency>
, DITaskEditingBuildable
, TaskEditingListener {

  private final class Component: RIBs.Component<DITaskEditingDependency>, TaskEditingDependency {}
  
  private weak var listener: DITaskEditingListener?
  
  required public override init(dependency: DITaskEditingDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: DITaskEditingListener, mode: DITaskEditingViewMode) -> DITaskEditingRouting {
    let component = Component(dependency: dependency)
    let builder = TaskEditingBuilder(dependency: component)
    self.listener = listener
    let _mode: TaskEditingViewMode
    switch mode {
    case let .edit(task):
      _mode = .edit(task)
    case .new:
      _mode = .new
    }
    return builder.build(withListener: self, mode: _mode)
  }
  
  // MARK: TaskEditingListener
  
  public func taskEditingDidFinish() {
    self.listener?.taskEditingDidFinish()
  }
}
