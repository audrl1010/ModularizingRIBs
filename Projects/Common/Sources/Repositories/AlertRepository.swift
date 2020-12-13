//
//  AlertRepository.swift
//  Common
//
//  Created by myunggison on 12/13/20.
//

import UIKit
import RxSwift
import URLNavigator

public protocol AlertActionType {
  var title: String? { get }
  var style: UIAlertAction.Style { get }
}

extension AlertActionType {
    var style: UIAlertAction.Style {
    return .default
  }
}

public protocol AlertRepositoryProtocol: class {
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action]
  ) -> Observable<Action>
}

final class AlertRepository: AlertRepositoryProtocol {

  public func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action]
  ) -> Observable<Action> {
    return Observable.create { observer in
      let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
      for action in actions {
        let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
          observer.onNext(action)
          observer.onCompleted()
        }
        alert.addAction(alertAction)
      }
      Navigator().present(alert)
      return Disposables.create {
        alert.dismiss(animated: true, completion: nil)
      }
    }
  }
}
