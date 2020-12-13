//
//  TasksViewController.swift
//  Tasks
//
//  Created by myunggison on 12/12/20.
//

import RIBs
import RxSwift
import RxCocoa
import RxCocoa_Texture
import RxDataSources_Texture
import AsyncDisplayKit
import ReactorKit
import BonMot
import Common

public enum TasksViewAction {
  case refresh
  case toggleEditing
  case addTask
  case editTask(IndexPath)
  case toggleTaskDone(IndexPath)
  case deleteTask(IndexPath)
  case moveTask(IndexPath, IndexPath)
}

typealias TasksViewReactor = (
  state: Observable<TasksViewState>,
  currentState: TasksViewState,
  action: ActionSubject<TasksViewAction>
)

public protocol TasksPresentableListener: class {
  var state: Observable<TasksViewState> { get }
  var currentState: TasksViewState { get }
  var action: ActionSubject<TasksViewAction> { get }
}

final class TasksViewController
  : BaseASViewController
  , TasksPresentable
  , TasksViewControllable {
  
  // MARK: Properties
  
  weak var listener: TasksPresentableListener?

  var targetViewController: ViewControllable?
  
  var animationInProgress: Bool = false
  
  private lazy var dataSource = self.createDataSource()
  
  private let listAdapter: TasksListAdapter

  lazy var tableNode = ASTableNode().then {
    $0.backgroundColor = .clear
    $0.allowsSelectionDuringEditing = true
    $0.view.contentInsetAdjustmentBehavior = .never
  }
  
  private let activityIndicatorView = UIActivityIndicatorView(style: .large)
  
  private let addButtonItem = UIBarButtonItem(
    barButtonSystemItem: .add,
    target: nil,
    action: nil
  )

  init(listAdapter: TasksListAdapter) {
    self.listAdapter = listAdapter
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem
    self.navigationItem.rightBarButtonItem = self.addButtonItem
    
    self.view.addSubview(self.activityIndicatorView)
    
    self.activityIndicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    guard let state = self.listener?.state else { return }
    guard let currentState = self.listener?.currentState else { return }
    guard let action = self.listener?.action else { return }
    
    let reactor = (state, currentState, action)
    
    self.bindDelegate(reactor: reactor)
    self.bindDataSources(reactor: reactor)
    self.bindLoading(reactor: reactor)
    self.bindRefresh(reactor: reactor)
    self.bindAddTask(reactor: reactor)
    self.bindEditing(reactor: reactor)
    self.bindTaskMoved(reactor: reactor)
    self.bindTaskDeleted(reactor: reactor)
    self.bindTaskSelected(reactor: reactor)
  }
  
  // MARK: Bind
  
  private func bindDelegate(reactor: TasksViewReactor) {
    self.tableNode.rx.setDelegate(self)
      .disposed(by: self.disposeBag)
  }
  
  private func bindDataSources(reactor: TasksViewReactor) {
    self.dataSource.canEditRowAtIndexPath = { _, _  in true }
    self.dataSource.canMoveRowAtIndexPath = { _, _  in true }
    
    reactor.state.map { $0.sections }
      .distinctUntilChanged()
      .bind(to: self.tableNode.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
  
  private func bindRefresh(reactor: TasksViewReactor) {
    self.rx.viewDidAppear
      .take(1)
      .map { _ in .refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindLoading(reactor: TasksViewReactor) {
    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)
  }
  
  private func bindAddTask(reactor: TasksViewReactor) {
    self.addButtonItem.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { TasksViewAction.addTask }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindEditing(reactor: TasksViewReactor) {
    self.editButtonItem.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { TasksViewAction.toggleEditing }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.isEditing }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] isEditing in
        guard let self = self else { return }
        self.navigationItem.leftBarButtonItem?.title = isEditing ? "Done" : "Edit"
        self.navigationItem.leftBarButtonItem?.style = isEditing ? .done : .plain
        self.tableNode.view.setEditing(isEditing, animated: true)
      })
      .disposed(by: self.disposeBag)
    
    self.tableNode.rx.itemSelected
      .filter { [weak self] _ in self?.listener?.currentState.isEditing ?? false }
      .map { indexPath in .editTask(indexPath) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindTaskMoved(reactor: TasksViewReactor) {
    self.tableNode.rx.itemMoved
      .map(TasksViewAction.moveTask)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindTaskDeleted(reactor: TasksViewReactor) {
    self.tableNode.rx.itemDeleted
      .map(TasksViewAction.deleteTask)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindTaskSelected(reactor: TasksViewReactor) {
    self.tableNode.rx.itemSelected
      .filter{ [weak self] _ in !(self?.listener?.currentState.isEditing ?? false) }
      .map { indexPath in .toggleTaskDone(indexPath) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return self.contentLayout()
  }
  
  private func contentLayout() -> ASLayoutSpec {
    ASInsetLayoutSpec(
      insets: UIEdgeInsets(
        top: self.view.safeAreaInsets.top,
        left: 0,
        bottom: self.view.safeAreaInsets.bottom,
        right: 0
      ),
      child: self.tableNode
    )
  }
}

extension TasksViewController {
  func createDataSource() -> RxASTableSectionedAnimatedDataSource<TasksViewSection> {
    .init(
      configureCellBlock: { dataSource, tableNode, indexPath, sectionItem -> ASCellNodeBlock in
        switch sectionItem {
        case let .task(cellReactor):
          return {
            let cell = TaskItemNode(reactor: cellReactor)
            return cell
          }
        }
      }
    )
  }
}

// MARK: - ASTableDelegate

extension TasksViewController: ASTableDelegate {
  
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    tableNode.deselectRow(at: indexPath, animated: true)
  }
}
