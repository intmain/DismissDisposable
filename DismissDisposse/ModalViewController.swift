//
//  ModalViewController.swift
//  DismissDisposse
//
//  Created by intmain on 2019/08/02.
//  Copyright © 2019 intmain. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

class ModalViewController: UIViewController {
  
  let closeButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: nil, action: nil)
  let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: nil)
  let textField: UITextField = UITextField()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(textField)
    view.backgroundColor = UIColor.lightGray
    navigationItem.rightBarButtonItem = closeButton
    navigationItem.leftBarButtonItem = doneButton
    textField.text = "text"
    textField.backgroundColor = UIColor.white
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    textField.frame = CGRect(x: 10, y: 100, width: 100, height: 30)
  }
  
  static func create(parent: UIViewController?) -> Observable<String> {
    return Observable<ModalViewController>.create { observer -> Disposable in
      let modal = ModalViewController()
      let cancelButtonDisposable = modal.closeButton.rx.tap
        .subscribe(onNext: { _ in
          observer.onCompleted()
        })
      
      let navi = UINavigationController(rootViewController: modal)
      parent?.present(navi, animated: true, completion: {
        observer.onNext(modal)
      })
      
      return Disposables.create([cancelButtonDisposable, Disposables.create { [weak modal] in
        modal?.dismiss(animated: true, completion: nil)
        }])
      }
      .flatMapFirst { modal -> Observable<String> in
        return modal.doneButton.rx.tap.flatMap { _ -> Observable<String> in
          return modal.textField.rx.text.filterNil().asObservable()
        }
      }.take(1)
  }
  
}
