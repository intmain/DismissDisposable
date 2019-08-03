//
//  ViewController.swift
//  DismissDisposse
//
//  Created by intmain on 2019/08/02.
//  Copyright © 2019 intmain. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  let showModalButton: UIButton = UIButton(type: .system)
  let disposeBag: DisposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(showModalButton)
    view.backgroundColor = UIColor.white
    showModalButton.setTitle("show modal", for: .normal)
    bind()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    showModalButton.sizeToFit()
    showModalButton.center = view.center
  }
  
  func bind() {
    showModalButton.rx.tap
      .flatMap { [weak self] _ in
        return ModalViewController.create(parent: self)
      }
      .subscribe(onNext: { [weak self] text in
        self?.showModalButton.setTitle(text, for: .normal)
      })
      .disposed(by: disposeBag)
  }
}

