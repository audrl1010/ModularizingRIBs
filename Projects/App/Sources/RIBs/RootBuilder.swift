//
//  RootBuilder.swift
//  App
//
//  Created by myunggison on 12/12/20.
//

import RIBs
import Common

protocol RootDependency: Dependency {
}

final class RootComponent: Component<RootDependency> {
  let rootViewController: RootViewController
  
  init(dependency: RootDependency, rootViewController: RootViewController) {
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}

protocol RootBuildable: Buildable {
  func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler)
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
  
  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }
  
  func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler) {
    let viewController = RootViewController()
    let component = RootComponent(
      dependency: self.dependency,
      rootViewController: viewController
    )
    let interactor = RootInteractor(presenter: viewController)
    
    let tasksBuilder: DITasksBuildable = ribsDIContainer.resolve(DITasksBuildable.self, argument: component as DITasksDependency)!
    let router = RootRouter(
      interactor: interactor,
      viewController: viewController,
      tasksBuilder: tasksBuilder
    )
    return (router, interactor)
  }
}
