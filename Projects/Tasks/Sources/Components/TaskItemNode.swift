//
//  TaskItemNode.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//

import AsyncDisplayKit
import ReactorKit
import Common
import BonMot
import RxCocoa_Texture

public class TaskItemNode: BaseASCellNode, ReactorKit.View {
  
  enum Typo {
    static let title = StringStyle([
      .font(UIFont.systemFont(ofSize: 14)),
      .color(UIColor.black)
    ])
  }
  
  let titleNode = ASTextNode().then {
    $0.maximumNumberOfLines = 1
  }
  
  public override init() {
    super.init()
    self.style.width = .init(unit: .fraction, value: 1.0)
    self.style.height = .init(unit: .points, value: 54)
  }
  
  public init(reactor: TaskItemReactor) {
    defer { self.reactor = reactor }
    super.init()
    self.style.width = .init(unit: .fraction, value: 1.0)
    self.style.height = .init(unit: .points, value: 54)
  }
  
  public func bind(reactor: TaskItemReactor) {
    self.titleNode.attributedText = reactor.currentState.title.styled(with: Typo.title)
    self.accessoryType = reactor.currentState.isMarked ? .checkmark : .none
    self.setNeedsLayout()
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(
      insets: .init(top: 16, left: 20, bottom: 16, right: 20), child: self.contentLayout()
    )
  }
  
  private func contentLayout() -> ASLayoutSpec {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        self.titleNode.styled {
          $0.flexGrow = 1
          $0.flexShrink = 1
        }
      ]
    )
  }
}
