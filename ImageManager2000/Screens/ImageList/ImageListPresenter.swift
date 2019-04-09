//
//  ImageListPresenter.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/9/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import Foundation
import UIKit

protocol ImageListPresenterDelegate: class {
    func imageListPresenterDidSelect(_ resource: Resource)
}

class ImageListPresenter {
    private weak var view: ImageListView?
    private var resourceService: ResourceService
    private weak var delegate: ImageListPresenterDelegate?

    init(resourceService: ResourceService, delegate: ImageListPresenterDelegate) {
        self.resourceService = resourceService
        self.delegate = delegate
    }
}

extension ImageListPresenter: ImageListPresent {
    
    func attach(_ view: ImageListView) {
        self.view = view
    }
    
    func viewDidLoad() {
        resourceService.fetchAll { [unowned self] (resources, error) in
            self.view?.show(resources ?? [])
        }
    }
    
    func selectAction(_ resource: Resource) {
        delegate?.imageListPresenterDidSelect(resource)
        view?.dismiss()
    }
    
    func loadImage(_ resource: Resource, handler: @escaping (UIImage?) -> ()) {
        resourceService.loadLocalImage(for: resource, completion: handler)
    }
}
