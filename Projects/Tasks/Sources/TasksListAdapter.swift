//
//  TasksListAdapter.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//

import RxSwift
import RxRelay
import AsyncDisplayKit
import Common

final class TasksListAdapter: CollectionListAdapter {
  
  typealias ViewController = TasksViewController
  typealias Section = TasksViewSection
  typealias SectionItem = TasksViewSection.Item
  typealias Reactor = TasksViewReactor
  
  weak var viewController: ViewController?
  
  func cellNode(collectionNode: ASCollectionNode, indexPath: IndexPath, reactor: Reactor, sectionItem: SectionItem) -> ASCellNodeBlock {
    return { ASCellNode() }
  }
  
  func supplementaryNode(collectionNode: ASCollectionNode, kind: String, indexPath: IndexPath, reactor: Reactor, section: Section) -> ASCellNode {
    return ASCellNode()
  }

  func margin(collectionNode: ASCollectionNode, layout: UICollectionViewLayout, section: Section) -> UIEdgeInsets {
    return .zero
  }
  
  func interitemSpacing(section: Section) -> CGFloat {
    return 0
  }
  
  func lineSpacing(section: Section) -> CGFloat {
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
  
  func footerSize(collectionNode: ASCollectionNode, section: TasksViewSection) -> ASSizeRange {
    return ASSizeRange(
      min: CGSize(width: collectionNode.view.width, height: 0),
      max: CGSize(width: collectionNode.view.width, height: CGFloat.infinity)
    )
  }
}
