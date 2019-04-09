//
//  ImageListBuilder.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/9/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import Foundation

class ImageListBuilder {
    class func instantiateScreen(resourceService: ResourceService, delegate: ImageListPresenterDelegate) -> ImageListViewController {
        let vc = ImageListViewController()
        let presenter = ImageListPresenter(resourceService: resourceService, delegate: delegate)
        vc.attach(presenter)
        presenter.attach(vc)
        return vc
    }
}
