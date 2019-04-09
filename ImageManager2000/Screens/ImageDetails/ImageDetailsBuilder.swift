//
//  ImageDetailsBuilder.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/9/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import Foundation

class ImageDetailsBuilder {
    class func instantiateScreen(resourceService: ResourceService) -> ImageDetailsViewController {
        let vc = ImageDetailsViewController()
        let presenter = ImageDetailsPresenter(resourceService: resourceService)
        vc.attach(presenter)
        presenter.attach(vc)
        return vc
    }
}
