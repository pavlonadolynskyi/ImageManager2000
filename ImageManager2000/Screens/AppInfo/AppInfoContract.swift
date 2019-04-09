//
//  AppInfoContract.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/9/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

protocol AppInfoPresent {
    func attach(_ view: AppInfoView)
    func viewDidLoad()
    func okAction()
}

protocol AppInfoView: AppView {
    func attach(_ presenter: AppInfoPresent)
}
