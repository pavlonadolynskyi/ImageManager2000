//
//  ImageListViewController.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/3/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageListViewController: UIViewController {
    fileprivate var presenter: ImageListPresent?

    @IBOutlet private weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    let items: BehaviorRelay<[Resource]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reuseIdentifier = "ImageListTableViewCell"
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier)) { (row, element, cell) in
                if let cell = cell as? ImageListTableViewCell {
                    cell.numberLabel.text = "Image number \(row + 1)"
                    cell.titleLabel.text = element.name
                    self.presenter?.loadImage(element, handler: { (image) in
                        cell.thumbnailImageView?.image = image
                    })
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Resource.self)
            .subscribe(onNext: { [unowned self] value in
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: indexPath, animated: false)
                }
                self.presenter?.selectAction(value)
            })
            .disposed(by: disposeBag)
        
        presenter?.viewDidLoad()
    }
}

extension ImageListViewController: ImageListView {
    func attach(_ presenter: ImageListPresent) {
        self.presenter = presenter
    }
    
    func show(_ items: [Resource]) {
        self.items.accept(items)
    }
}
