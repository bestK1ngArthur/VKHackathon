//
//  Achievement.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class Achievement {

    enum Category: String {
        case it = "Информационные технологии"
        case math = "Математика"
        case chem = "Химия"
        case bio = "Биология"
        case phys = "Физика"
        case proj = "Проектная смена"
    }
    
    let title: String
    let description: String
    let address: String
    let url: URL?
    let complexity: Double
    let isCompleted: Bool
    let category: Category
    
    init(title: String, description: String, address: String, url: URL? = nil, complexity: Double, isCompleted: Bool, category: Category = .it) {
        self.title = title
        self.description = description
        self.address = address
        self.url = url
        self.complexity = complexity
        self.isCompleted = isCompleted
        self.category = category
    }
    
    static var empty: Achievement {
        return Achievement(title: "", description: "", address: "", complexity: 0, isCompleted: true)
    }
    
    var isEmpty: Bool {
        return title.isEmpty
    }
    
    var categoryImage: UIImage? {
        switch category {
        case .it:
            return UIImage(named: "it_ic")
        case .math:
            return UIImage(named: "math_ic")
        case .chem:
            return UIImage(named: "chem_ic")
        case .bio:
            return UIImage(named: "bio_ic")
        case .phys:
            return UIImage(named: "phys_ic")
        case .proj:
            return UIImage(named: "proj_ic")
        default:
            break
        }
    }
}
