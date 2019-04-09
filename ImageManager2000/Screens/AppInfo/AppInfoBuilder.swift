//
//  AppInfoBuilder.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/9/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import Foundation

class AppInfoBuilder {
    class func instantiateScreen() -> AppInfoViewController {
        let vc = AppInfoViewController()
        let presenter = AppInfoPresenter()
        vc.attach(presenter)
        presenter.attach(vc)
        return vc
    }
}
