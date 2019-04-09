//
//  AppInfoPresenter.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/9/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import Foundation
import RxSwift

class AppInfoPresenter {
    private weak var view: AppInfoView?
    
    let closeSubject = PublishSubject<NSInteger>()
    private let disposeBag = DisposeBag()
}

extension AppInfoPresenter: AppInfoPresent {
    func attach(_ view: AppInfoView) {
        self.view = view
    }
    
    func viewDidLoad() {
        let dueTime: NSInteger = 10
        let timer = Observable<NSInteger>.timer(RxTimeInterval(dueTime), scheduler: MainScheduler.instance)

        Observable.of(timer, closeSubject)
            .merge()
            .take(1)
            .subscribe({ (event) in
                if event.isCompleted {
                    self.view?.dismiss()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func okAction() {
        closeSubject.onNext(0)
    }
}
