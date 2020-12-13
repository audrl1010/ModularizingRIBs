//
//  TaskItemNodePreview.swift
//  Tasks
//
//  Created by myunggison on 12/13/20.
//

import Tasks
import Common

#if canImport(SwiftUI) && DEBUG
import SwiftUI

let task1 = Task(
  id: UUID().uuidString,
  title: "Task item title case 1",
  memo: "",
  isMarked: true,
  createdAt: Date(),
  updateAt: Date()
)

let task2 = Task(
  id: UUID().uuidString,
  title: "Task item title case 2",
  memo: "",
  isMarked: false,
  createdAt: Date(),
  updateAt: Date()
)

@available(iOS 13.0, *)

struct TaskItemPreview: UIViewRepresentable {
  let taskItemNode = TaskItemNode()
  
  init(task: Task) {
    taskItemNode.reactor = TaskItemReactor(task: task)
  }
  
  func makeUIView(context: Context) -> UIView {
    return self.taskItemNode.view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
  }
}

struct TaskItemNode_Previews: PreviewProvider  {
  static var previews: some View {
    VStack {
      ForEach([task1, task2], id: \.self) { task in
        TaskItemPreview(task: task)
          .frame(width: 300, height: 54)
      }
    }
  }
}
#endif
