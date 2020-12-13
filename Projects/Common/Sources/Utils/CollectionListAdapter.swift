//
//  CollectionListAdapter.swift
//  Common
//
//  Created by myunggison on 12/12/20.
//

import AsyncDisplayKit

public protocol CollectionListAdapter: class {
  
  associatedtype Section
  associatedtype SectionItem
  associatedtype Reactor
  associatedtype ViewController
  
  var viewController: ViewController? { get set }
  
  func cellNode(collectionNode: ASCollectionNode, indexPath: IndexPath, reactor: Reactor, sectionItem: SectionItem) -> ASCellNodeBlock
  func supplementaryNode(collectionNode: ASCollectionNode, kind: String, indexPath: IndexPath, reactor: Reactor, section: Section) -> ASCellNode
  func margin(collectionNode: ASCollectionNode, layout: UICollectionViewLayout, section: Section) -> UIEdgeInsets
  func lineSpacing(section: Section) -> CGFloat
  func interitemSpacing(section: Section) -> CGFloat
  func itemSize(collectionNode: ASCollectionNode, indexPath: IndexPath, sectionItem: SectionItem) -> ASSizeRange
  func headerSize(collectionNode: ASCollectionNode, section: Section) -> ASSizeRange
  func footerSize(collectionNode: ASCollectionNode, section: Section) -> ASSizeRange
}

extension CollectionListAdapter {
  
  func supplementaryNode(collectionNode: ASCollectionNode, kind: String, indexPath: IndexPath, reactor: Reactor, section: Section) -> ASCellNode {
    return ASCellNode()
  }
  
  func margin(collectionNode: ASCollectionNode, layout: UICollectionViewLayout, section: Section) -> UIEdgeInsets {
    return .zero
  }
  
  func lineSpacing(section: Section) -> CGFloat {
    return 0
  }
  
  func interitemSpacing(section: Section) -> CGFloat {
    return 0
  }
  
  func itemSize(collectionNode: ASCollectionNode, indexPath: IndexPath, sectionItem: SectionItem) -> ASSizeRange {
    return ASSizeRange(
      min: CGSize(width: collectionNode.view.width, height: 0),
      max: CGSize(width: collectionNode.view.width, height: CGFloat.infinity)
    )
  }
  
  func headerSize(collectionNode: ASCollectionNode, section: Section) -> ASSizeRange {
    return ASSizeRange(
      min: CGSize(width: collectionNode.view.width, height: 0),
      max: CGSize(width: collectionNode.view.width, height: CGFloat.infinity)
    )
  }
  
  func footerSize(collectionNode: ASCollectionNode, section: Section) -> ASSizeRange {
    return ASSizeRange(
      min: CGSize(width: collectionNode.view.width, height: 0),
      max: CGSize(width: collectionNode.view.width, height: CGFloat.infinity)
    )
  }
}
