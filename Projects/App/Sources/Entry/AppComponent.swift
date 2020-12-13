//
//  AppComponent.swift
//  App
//
//  Created by myunggison on 12/13/20.
//

import RIBs
import Common
import Tasks
import TaskEditing

class AppComponent: Component<EmptyDependency>, RootDependency {
  
  init() {
    super.init(dependency: EmptyComponent())
    
    ribsDIContainer.register(DITasksBuildable.self) { _, arg1 in
      DITasksBuilerAdapter(dependency: arg1)
    }
    .inObjectScope(.container)
    
    ribsDIContainer.register(DITaskEditingBuildable.self) { _, arg1 in
      DITaskEditingBuilerAdapter(dependency: arg1)
    }
    .inObjectScope(.container)
   }
}
