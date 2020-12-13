//
//  RootInteractor.swift
//  App
//
//  Created by myunggison on 12/12/20.
//
import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
  func routeToTask()
  func detachTaskEditing()
}

protocol RootPresentable: Presentable {
  var listener: RootPresentableListener? { get set }
}

protocol RootListener: class {
}

final class RootInteractor
  : PresentableInteractor<RootPresentable>
  , RootInteractable
  , RootPresentableListener {
  
  weak var router: RootRouting?
  weak var listener: RootListener?
  
  override init(presenter: RootPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.router?.routeToTask()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
}

extension RootInteractor: UrlHandler {
  func handle(_ url: URL) {}
}
