//
//  BaseASCellNode.swift
//  Common
//
//  Created by myunggison on 12/12/20.
//

import AsyncDisplayKit
import RxSwift

open class BaseASCellNode: ASCellNode {
  
  public var disposeBag = DisposeBag()
  
  public override init() {
    super.init()
    self.backgroundColor = .white
    self.automaticallyManagesSubnodes = true
    self.isUserInteractionEnabled = true
  }
  
  public func createSpace(width: CGFloat? = nil, height: CGFloat? = nil) -> ASLayoutElement {
    return ASDisplayNode().styled {
      if let width = width {
        $0.preferredSize.width = width
      }
      if let height = height {
        $0.preferredSize.height = height
      }
    }
  }
}
