//
//  ImageDetailsPresenter.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/8/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import Foundation
import UIKit

class ImageDetailsPresenter {
    private weak var view: ImageDetailsView?
    private var resourceService: ResourceService

    private var currentResource: Resource?

    init(resourceService: ResourceService) {
        self.resourceService = resourceService
    }
}

extension ImageDetailsPresenter: ImageDetailsPresent {
    func attach(_ view: ImageDetailsView) {
        self.view = view
    }
    
    func viewDidLoad() {
        randomAction()
    }
    
    func loadImage(_ resource: Resource, handler: @escaping (UIImage?) -> ()) {
        resourceService.loadLocalImage(for: resource, completion: handler)
    }
    
    func infoAction() {
        let vc = AppInfoBuilder.instantiateScreen()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        view?.presentModally(vc: vc)
    }
    
    func nameChanged(_ text: String?) {
        guard var resource = currentResource else { return }
        resource.name = text
        resourceService.updateResource(resource)
    }
    
    func randomAction() {
        view?.showHUD()
        resourceService.fetchRandom { [unowned self] (resource, error) in
            self.view?.hideHUD()

            guard let resource = resource else { return }
            self.currentResource = resource
            
            self.view?.display(resource: resource)
        }
    }
    
    func selectAction() {
        let vc = ImageListBuilder.instantiateScreen(resourceService: resourceService, delegate: self)
        view?.presentModally(vc: vc)
    }
}

extension ImageDetailsPresenter: ImageListPresenterDelegate {
    func imageListPresenterDidSelect(_ resource: Resource) {
        self.currentResource = resource

        self.view?.display(resource: resource)
    }
}
