//
//  RMTaskList.swift
//  Common
//
//  Created by myunggison on 12/12/20.
//

import RealmSwift

@objcMembers class RMTaskList: Object {
  
  enum Property: String {
    case id, tasks
  }
  
  dynamic var id: String = UUID().uuidString
  dynamic var tasks: List<RMTask> = List<RMTask>()
  
  override static func primaryKey() -> String? {
    return Property.id.rawValue
  }
}
