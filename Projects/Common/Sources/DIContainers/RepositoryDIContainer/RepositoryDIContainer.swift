//
//  RepositoryDIContainer.swift
//  Common
//
//  Created by myunggison on 12/13/20.
//

import Swinject
import RealmSwift

public func repositoryResolve<T>(_ type: T.Type) -> T {
  if !_repositoryRegisteredFlag {
    _registerRepositories()
    _repositoryRegisteredFlag = true
  }
  return _repositoryDIContainer.resolve(type)!
}

private var _repositoryRegisteredFlag: Bool = false

private let _repositoryDIContainer = Container()

private func _registerRepositories() {
  _repositoryDIContainer.register(TaskDatabaseProtocol.self) { r in
    TaskRealmDatabase()
  }.inObjectScope(.container)
  
  _repositoryDIContainer.register(TaskRepositoryProtocol.self) { r in
    let database = r.resolve(TaskDatabaseProtocol.self)!
    return TaskRepositoryImpl(database: database)
  }.inObjectScope(.container)
  
  _repositoryDIContainer.register(AlertRepositoryProtocol.self) { r in
    AlertRepository()
  }.inObjectScope(.container)
}
