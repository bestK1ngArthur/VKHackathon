//
//  AppManager.swift
//  HackathonApp
//
//  Created by a.belkov on 10/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Foundation

import Alamofire
import CSV

class AppManager {

    static let shared = AppManager()
    
    init() {
        loadAchievements()
        loadUserAchievements()
        updateUserLevel()
    }
    
    var needToUpdateLevels: Bool = false
    
    var currentUserID: Int? {
        set {
            UserDefaults.standard.set(newValue, forKey: "user_id")
        }
        
        get {
            let id = UserDefaults.standard.integer(forKey: "user_id")
            if id == 0 {
                return 1 // nil
            } else {
                return id
            }
        }
    }
    
    var currentUserName: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "username")
        }
        
        get {
            return UserDefaults.standard.string(forKey: "username") ?? nil
        }
    }
    
    var currentUserCategory: Achievement.Category {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "category")
        }
        
        get {
            return Achievement.Category(rawValue: (UserDefaults.standard.string(forKey: "category") ?? "")) ?? .chem
        }
    }
    
    var currentUserLevel: Double {
        set {
            UserDefaults.standard.set(newValue, forKey: "user_level")
        }
        
        get {
            return UserDefaults.standard.double(forKey: "user_level")
        }
    }
    
    let categories: [(image: UIImage, title: String)] = [(image: UIImage(named: "it_ic")!, title: "Информационные технологии"), (image: UIImage(named: "math_ic")!, title: "Математика"), (image: UIImage(named: "chem_ic")!, title: "Химия"), (image: UIImage(named: "bio_ic")!, title: "Биология"), (image: UIImage(named: "phys_ic")!, title: "Физика"), (image: UIImage(named: "proj_ic")!, title: "Проектная смена")]
    
    private(set) var allAchievements: [Achievement] = []
    private(set) var userAchievements: [Achievement] = []

    private func loadAchievements() {
        
        var achievements: [Achievement] = []

        let filePath = Bundle.main.path(forResource: "Achievements", ofType: "csv") ?? ""
        let fileUrl = URL(string: "file://\(filePath)")!
        
        do {
            
            let text = try String(contentsOf: fileUrl, encoding: .utf8)
            let rows = text.components(separatedBy: "\n")
            
            for row in rows {
                
                let rowString = "\(row)"
                let values = rowString.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\r", with: "").components(separatedBy: ";")
                
                if values.indices.contains(2) {
                    if values[2] == "name " {
                        continue
                    }
                }
                
                var title: String = ""
                var description: String = ""
                var address: String = ""
                var category: Achievement.Category = .it
                var isCompleted: Bool = false
                
                var url: URL?
                var complexity: Double = 1
                
                if values.indices.contains(2) {
                    title = values[2]
                }
                
                if values.indices.contains(4) {
                    description = values[4]
                }
                
                if values.indices.contains(6) {
                    address = values[6]
                }
                
                if values.indices.contains(1) {
                    url = URL(string: values[1])
                }
                
                if values.indices.contains(9) {
                    complexity = Double(values[9]) ?? Double.random(in: 0...10)
                }
                
                if values.indices.contains(5) {
                    category = Achievement.Category(rawValue: values[5]) ?? .it
                }
                
                if values.indices.contains(7) {
                    isCompleted = Int(values[7]) == 1
                }
                
                let achievement = Achievement(title: title, description: description, address: address, url: url, complexity: complexity, isCompleted: isCompleted, category: category)
                
                achievements.append(achievement)
            }
        }
        catch {/* error handling here */}
        
//        let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "Achievements", ofType: "csv") ?? "")!
//        let csv = try! CSVReader(stream: stream)
//
//        while let row = csv.next() {
//
//            let rowString = "\(row)"
//            let values = rowString.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\"", with: "").components(separatedBy: ";")
//
//            var title: String = ""
//            var description: String = ""
//            var address: String = ""
//            var url: URL?
//            var complexity: Double = 1
//
//            if values.indices.contains(2) {
//                title = values[2]
//            }
//
//            if values.indices.contains(4) {
//                description = values[4]
//            }
//
//            if values.indices.contains(6) {
//                address = values[6]
//            }
//
//            if values.indices.contains(1) {
//                complexity = Double(values[1]) ?? 1
//            }
//
//            if values.indices.contains(9) {
//                complexity = Double(values[9]) ?? 1
//            }
//
//            let achievement = Achievement(title: title, description: description, address: address, url: url, complexity: complexity, isCompleted: false)
//
//            allAchievements.append(achievement)
//        }

        self.allAchievements = achievements
    }
    
    func loadUserAchievements() {
        self.userAchievements = self.achievements(for: self.currentUserCategory)
    }
    
    func achievements(for category: Achievement.Category) -> [Achievement] {
        
        var achievements: [Achievement] = []
        for achievement in allAchievements {
            
            if achievement.category == category {
                achievements.append(achievement)
            } else if Int.random(in: 0..<10) == 3 {
                achievements.append(achievement)
            }
        }
        
        return achievements
    }
    
    func addUserAchievement(_ achievement: Achievement) {
        self.userAchievements.append(achievement)
        self.needToUpdateLevels = true
    }
    
    func completeAchievement(_ achievement: Achievement) {
        
        if let achIndex = self.allAchievements.firstIndex(where: { (ch) -> Bool in
            return (achievement.title == ch.title) && (achievement.description == ch.description)
        }) {
            let ach = self.allAchievements[achIndex]
            ach.isCompleted = true
            self.allAchievements[achIndex] = ach
        }
        
        if let achIndex = self.userAchievements.firstIndex(where: { (ch) -> Bool in
            return (achievement.title == ch.title) && (achievement.description == ch.description)
        }) {
            let ach = self.userAchievements[achIndex]
            ach.isCompleted = true
            self.userAchievements[achIndex] = ach
        }
        
        needToUpdateLevels = true
    }
    
    func updateUserLevel() {
        
        var level: Double = 0
        for achievement in self.userAchievements where achievement.isCompleted {
            level += achievement.complexity / 8
        }
        
        currentUserLevel = level
    }
}
