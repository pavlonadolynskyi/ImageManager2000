//
//  AppInfoViewController.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/3/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {
    fileprivate var presenter: AppInfoPresent?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/YYYY HH:mm"
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Created by (\(Constants.creatorName))"
        let timeString = dateFormatter.string(from: Date())
        messageLabel.text = "The time now is: \(timeString)"

        presenter?.viewDidLoad()
    }
    
    @IBAction func okAction(_ sender: Any) {
        presenter?.okAction()
    }
}

extension AppInfoViewController: AppInfoView {
    func attach(_ presenter: AppInfoPresent) {
        self.presenter = presenter
    }
}
