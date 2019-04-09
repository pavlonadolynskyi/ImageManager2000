//
//  AppView.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/9/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import UIKit
import PKHUD

protocol AppView: class {
    func presentModally(vc: UIViewController)
    func dismiss()
    
    func showHUD()
    func hideHUD()
}

extension AppView where Self: UIViewController {
    func presentModally(vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func showHUD() {
        HUD.show(.progress, onView: view)
    }
    
    func hideHUD() {
        HUD.hide()
    }
}
