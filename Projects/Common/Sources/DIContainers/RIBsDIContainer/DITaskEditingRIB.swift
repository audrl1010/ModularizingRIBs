//
//  DITaskEditingRIB.swift
//  Common
//
//  Created by myunggison on 12/13/20.
//

import RIBs

public enum DITaskEditingViewMode {
  case new
  case edit(Task)
}

public protocol DITaskEditingListener: class {
  func taskEditingDidFinish()
}

public protocol DITaskEditingDependency: Dependency {
}

public protocol DITaskEditingBuildable: Buildable {
  init(dependency: DITaskEditingDependency)
  func build(withListener listener: DITaskEditingListener, mode: DITaskEditingViewMode) -> DITaskEditingRouting
}

public protocol DITaskEditingRouting: ViewableRouting {}
public protocol DITaskEditingViewControllable: ViewControllable {}
