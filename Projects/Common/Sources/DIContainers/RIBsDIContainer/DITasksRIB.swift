//
//  DITasksRIB.swift
//  Common
//
//  Created by myunggison on 12/13/20.
//

import RIBs

public protocol DITasksListener: class {
}

public protocol DITasksDependency: Dependency {
}

public protocol DITasksBuildable: Buildable {
  init(dependency: DITasksDependency)
  func build(withListener listener: DITasksListener) -> DITasksRouting
}

public protocol DITasksRouting: ViewableRouting {}
public protocol DITasksViewControllable: ViewControllable {}
