//
//  TitleInputNodePreview.swift
//  TaskEditing
//
//  Created by myunggison on 12/13/20.
//

import Foundation
import TaskEditing

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct TitleInputNode_Previews: UIViewRepresentable, PreviewProvider  {

  let titleInputNode: TitleInputNode = TitleInputNode()
  
  func makeUIView(context: Context) -> UIView {
    return titleInputNode.view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
  }

  static var previews: some View {
    TitleInputNode_Previews().previewLayout(.sizeThatFits)
      .frame(width: 300, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
  }
}
#endif
