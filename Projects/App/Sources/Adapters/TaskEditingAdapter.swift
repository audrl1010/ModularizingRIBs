//
//  TaskEditingAdapter.swift
//  App
//
//  Created by myunggison on 12/14/20.
//

import Foundation
import RIBs
import Common
import Tasks

public class DITasksBuilerAdapter
: Builder<DITasksDependency>
, DITasksBuildable
, TasksListener {

  private final class Component: RIBs.Component<DITasksDependency>, TasksDependency {}
  
  private weak var listener: DITasksListener?
  
  required public override init(dependency: DITasksDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: DITasksListener) -> DITasksRouting {
    let component = Component(dependency: dependency)
    let builder = TasksBuilder(dependency: component)
    self.listener = listener
    return builder.build(withListener: self)
  }
}
