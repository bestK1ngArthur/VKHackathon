//
//  Achievement.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class Achievement {

    let title: String
    let description: String
    let address: String
    let url: URL?
    let isCompleted: Bool
    
    init(title: String, description: String, address: String, url: URL? = nil, isCompleted: Bool) {
        self.title = title
        self.description = description
        self.address = address
        self.url = url
        self.isCompleted = isCompleted
    }
}
