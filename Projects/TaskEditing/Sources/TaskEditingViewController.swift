//
//  TaskEditingViewController.swift
//  TaskEditing
//
//  Created by myunggison on 12/13/20.
//

import RIBs
import RxSwift
import AsyncDisplayKit
import RxSwift
import ReactorKit
import Common

public enum TaskEditingViewAction {
  case updateTaskTitle(String)
  case cancel
  case submit
}

public typealias TaskEditingViewReactor = (
  state: Observable<TaskEditingViewState>,
  action: ActionSubject<TaskEditingViewAction>
)

public protocol TaskEditingPresentableListener: class {
  var state: Observable<TaskEditingViewState> { get }
  var currentState: TaskEditingViewState { get }
  var action: ActionSubject<TaskEditingViewAction> { get }
}

public final class TaskEditingViewController
: BaseASViewController
, TaskEditingPresentable
, TaskEditingViewControllable {
  
  public weak var listener: TaskEditingPresentableListener?

  // MARK: UI
  
  let cancelButtonItem = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil,
    action: nil
  )
  let doneButtonItem = UIBarButtonItem(
    barButtonSystemItem: .done,
    target: nil,
    action: nil
  )
  let titleInputNode = TitleInputNode()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.leftBarButtonItem = self.cancelButtonItem
    self.navigationItem.rightBarButtonItem = self.doneButtonItem
    
    self.view.backgroundColor = .white

    guard let action = self.listener?.action else { return }
    guard let state = self.listener?.state else { return }
    let reactor = (state, action)
    
    self.bindCancel(reactor: reactor)
    self.bindSubmit(reactor: reactor)
    self.bindTitle(reactor: reactor)
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.titleInputNode.becomeFirstResponder()
  }
  
  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(
      insets: .init(
        top: self.view.safeAreaInsets.top,
        left: 0,
        bottom: self.view.safeAreaInsets.bottom,
        right: 0
      ),
      child: self.titleInputLayout()
    )
  }
  
  private func titleInputLayout() -> ASLayoutSpec {
    return ASInsetLayoutSpec(
      insets: UIEdgeInsets.init(top: 16, left: 16, bottom: .infinity, right: 16),
      child: self.titleInputNode
    )
  }
  
  private func bindCancel(reactor: TaskEditingViewReactor) {
    self.cancelButtonItem.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { TaskEditingViewAction.cancel }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.doneButtonItem.rx.isEnabled)
      .disposed(by: self.disposeBag)
  }
  
  private func bindSubmit(reactor: TaskEditingViewReactor) {
    self.doneButtonItem.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { TaskEditingViewAction.submit }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindTitle(reactor: TaskEditingViewReactor) {
    self.titleInputNode.textView.rx.text
      .filterNil()
      .skip(1)
      .map(TaskEditingViewAction.updateTaskTitle)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.asObservable().map { $0.title }
      .distinctUntilChanged()
      .bind(to: self.navigationItem.rx.title)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.taskTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInputNode.textView.rx.text)
      .disposed(by: self.disposeBag)
  }
}
