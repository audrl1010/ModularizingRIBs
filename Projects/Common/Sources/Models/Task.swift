//
//  Task.swift
//  Common
//
//  Created by myunggison on 12/12/20.
//

import Foundation

public struct Task: Hashable {
  public var id: String
  public var title: String
  public var memo: String
  public var isMarked: Bool
  public var createdAt: Date
  public var updateAt: Date
  
  public init(id: String, title: String, memo: String, isMarked: Bool, createdAt: Date, updateAt: Date) {
    self.id = id
    self.title = title
    self.memo = memo
    self.isMarked = isMarked
    self.createdAt = createdAt
    self.updateAt = updateAt
  }
}
