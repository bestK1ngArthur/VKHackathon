//
//  Level.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Foundation

class Level {

    let title: String?
    let achievements: [Achievement]
    
    init(title: String? = nil, achievements: [Achievement]) {
        self.title = title
        self.achievements = achievements
    }
}
