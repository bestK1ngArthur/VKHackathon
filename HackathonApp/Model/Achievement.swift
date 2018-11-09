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
    let complexity: Double
    let isCompleted: Bool
    
    init(title: String, description: String, address: String, url: URL? = nil, complexity: Double, isCompleted: Bool) {
        self.title = title
        self.description = description
        self.address = address
        self.url = url
        self.complexity = complexity
        self.isCompleted = isCompleted
    }
    
    static var empty: Achievement {
        return Achievement(title: "", description: "", address: "", complexity: 0, isCompleted: true)
    }
    
    var isEmpty: Bool {
        return title.isEmpty
    }
}
