//
//  BaseASViewController.swift
//  Common
//
//  Created by myunggison on 12/12/20.
//

import AsyncDisplayKit
import RxSwift

open class BaseASViewController: ASDKViewController<ASDisplayNode> {
  
  // MARK: Initializing
  
  public override init() {
    super.init(node: self.forwardingNode)
    
    self.configureNode()
    
    self.forwardInterfaceState()
    self.forwardLayoutSpec()
    self.forwardLayoutTransition()
  }
  
  required convenience public init?(coder aDecoder: NSCoder) {
    self.init()
  }
  
  private func configureNode() {
    self.node.automaticallyManagesSubnodes = true
    self.node.automaticallyRelayoutOnSafeAreaChanges = true
  }
  
  // MARK: View Life Cycle
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    self.node.backgroundColor = .white
    self.view.backgroundColor = .white
  }

  // MARK: Rx
  
  public var disposeBag = DisposeBag()

  
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
  
  // MARK: Forwarding
  
  private let forwardingNode = ForwardingDisplayNode()

  private func forwardInterfaceState() {
    self.forwardingNode.didEnterPreloadStateBlock = { [weak self] in
      self?.didEnterPreloadState()
    }
    self.forwardingNode.didExitPreloadStateBlock = { [weak self] in
      self?.didExitPreloadState()
    }
    self.forwardingNode.didEnterDisplayStateBlock = { [weak self] in
      self?.didEnterDisplayState()
    }
    self.forwardingNode.didExitDisplayStateBlock = { [weak self] in
      self?.didExitDisplayState()
    }
    self.forwardingNode.didEnterVisibleStateBlock = { [weak self] in
      self?.didEnterVisibleState()
    }
    self.forwardingNode.didExitVisibleStateBlock = { [weak self] in
      self?.didExitVisibleState()
    }
  }

  private func forwardLayoutSpec() {
    self.forwardingNode.layoutSpecBlock = { [weak self] _, sizeRange in
      return self?.layoutSpecThatFits(sizeRange) ?? ASLayoutSpec()
    }
  }

  private func forwardLayoutTransition() {
    self.forwardingNode.animateLayoutTransitionBlock = { [weak self] context, superBlock in
      self?.animateLayoutTransition(context, superBlock)
    }
  }


  // MARK: Interface State
  open func didEnterPreloadState() {
  }

  open func didExitPreloadState() {
  }

  open func didEnterDisplayState() {
  }

  open func didExitDisplayState() {
  }

  open func didEnterVisibleState() {
  }

  open func didExitVisibleState() {
  }

  // MARK: Layout Spec
  open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASLayoutSpec()
  }

  // MARK: Layout Transition
  private var animateLayoutTransitionSuperBlockStack: [AnimateLayoutTransitionSuperBlock] = []

  private func animateLayoutTransition(_ context: ASContextTransitioning, _ superBlock: AnimateLayoutTransitionSuperBlock?) {
    if let superBlock = superBlock {
      self.animateLayoutTransitionSuperBlockStack.append(superBlock)
    }

    self.animateLayoutTransition(context)

    if superBlock != nil {
      _ = self.animateLayoutTransitionSuperBlockStack.popLast()
    }
  }

  open func animateLayoutTransition(_ context: ASContextTransitioning) {
    self.animateLayoutTransitionSuperBlockStack.last?(context)
  }
}


private typealias AnimateLayoutTransitionSuperBlock = (ASContextTransitioning) -> Void

private final class ForwardingDisplayNode: ASDisplayNode {

  // MARK: Interface State
  
  var didEnterPreloadStateBlock: (() -> Void)?
  var didExitPreloadStateBlock: (() -> Void)?

  var didEnterDisplayStateBlock: (() -> Void)?
  var didExitDisplayStateBlock: (() -> Void)?

  var didEnterVisibleStateBlock: (() -> Void)?
  var didExitVisibleStateBlock: (() -> Void)?

  override func didEnterPreloadState() {
    super.didEnterPreloadState()
    self.didEnterPreloadStateBlock?()
  }

  override func didExitPreloadState() {
    super.didExitPreloadState()
    self.didExitPreloadStateBlock?()
  }

  override func didEnterDisplayState() {
    super.didEnterDisplayState()
    self.didEnterDisplayStateBlock?()
  }

  override func didExitDisplayState() {
    super.didExitDisplayState()
    self.didExitDisplayStateBlock?()
  }

  override func didEnterVisibleState() {
    super.didEnterVisibleState()
    self.didEnterVisibleStateBlock?()
  }

  override func didExitVisibleState() {
    super.didExitVisibleState()
    self.didExitVisibleStateBlock?()
  }
  

  // MARK: Layuot Transition
  
  var animateLayoutTransitionBlock: ((_ context: ASContextTransitioning, _ superBlock: AnimateLayoutTransitionSuperBlock?) -> Void)?

  override func animateLayoutTransition(_ context: ASContextTransitioning) {
    self.animateLayoutTransitionBlock?(context, super.animateLayoutTransition)
  }
}
