//
//  ImageDetailsContract.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/8/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import UIKit

protocol ImageDetailsPresent {
    func attach(_ view: ImageDetailsView)
    func viewDidLoad()
    func loadImage(_ resource: Resource, handler: @escaping (UIImage?) -> ())
    func infoAction()
    func nameChanged(_ text: String?)
    func randomAction()
    func selectAction()
}

protocol ImageDetailsView: AppView {
    func attach(_ presenter: ImageDetailsPresent)
    func display(resource: Resource)
}
