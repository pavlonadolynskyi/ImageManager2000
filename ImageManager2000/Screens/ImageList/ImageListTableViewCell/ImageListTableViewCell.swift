//
//  ImageListTableViewCell.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/3/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import UIKit

class ImageListTableViewCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
