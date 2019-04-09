//
//  ImageListContract.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/9/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import Foundation
import UIKit

protocol ImageListPresent {
    func attach(_ view: ImageListView)
    func viewDidLoad()
    func selectAction(_ resource: Resource)
    func loadImage(_ resource: Resource, handler: @escaping (UIImage?) -> ())
}

protocol ImageListView: AppView {
    func attach(_ presenter: ImageListPresent)
    func show(_ items: [Resource])
}
