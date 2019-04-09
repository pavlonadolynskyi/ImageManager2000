//
//  Resource.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/1/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import Foundation

struct Resource: Codable {
    var name: String?
    var remoteLink: String
    
    init(remoteLink: String) {
        self.remoteLink = remoteLink
    }
}

extension Resource {
    var localFilename: String {
        return remoteLink.data(using: .utf8)?.base64EncodedString() ?? ""
    }
}
