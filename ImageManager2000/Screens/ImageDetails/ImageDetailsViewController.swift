//
//  ImageDetailsViewController.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/3/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    fileprivate var presenter: ImageDetailsPresent?

    @IBOutlet private weak var resourceNameTextField: UITextField!
    @IBOutlet private weak var resourceImageImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    }
    
    @IBAction func onInfoAction(_ sender: Any) {
        presenter?.infoAction()
    }
    
    @IBAction func onRandomAction(_ sender: Any) {
        presenter?.randomAction()
    }
    
    @IBAction func onSelectAction(_ sender: Any) {
        presenter?.selectAction()
    }
}

extension ImageDetailsViewController: ImageDetailsView {
    func attach(_ presenter: ImageDetailsPresent) {
        self.presenter = presenter
    }
    
    func display(resource: Resource) {
        resourceNameTextField.text = resource.name
        
        presenter?.loadImage(resource, handler: { [unowned self] (image) in
            self.resourceImageImageView.image = image
        })
    }
}

extension ImageDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        presenter?.nameChanged(textField.text)

        return true
    }
}
