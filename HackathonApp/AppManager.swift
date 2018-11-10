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
    }
    
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
    
    let categories: [(image: UIImage, title: String)] = [(image: UIImage(named: "it_ic")!, title: "Информационные технологии"), (image: UIImage(named: "math_ic")!, title: "Математика"), (image: UIImage(named: "chem_ic")!, title: "Химия"), (image: UIImage(named: "bio_ic")!, title: "Биология"), (image: UIImage(named: "phys_ic")!, title: "Физика"), (image: UIImage(named: "proj_ic")!, title: "Проектная смена")]
    
    private(set) var achievements: [Achievement] = []
    
    private func loadAchievements() {
        
        var achievements: [Achievement] = []

        let filePath = Bundle.main.path(forResource: "Achievements", ofType: "csv") ?? ""
        let fileUrl = URL(string: "file://\(filePath)")!
        
        do {
            
            let text = try String(contentsOf: fileUrl, encoding: .utf8)
            let rows = text.components(separatedBy: "\n")
            
            for row in rows {
                
                let rowString = "\(row)"
                let values = rowString.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\"", with: "").components(separatedBy: ";")
                
                if values.indices.contains(2) {
                    if values[2] == "name " {
                        continue
                    }
                }
                
                var title: String = ""
                var description: String = ""
                var address: String = ""
                var category: Achievement.Category = .it
                
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
                    complexity = Double(values[9]) ?? 1
                }
                
                if values.indices.contains(5) {
                    category = Achievement.Category(rawValue: values[5]) ?? .it
                }
                
                let achievement = Achievement(title: title, description: description, address: address, url: url, complexity: complexity, isCompleted: true, category: category)
                
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
//            achievements.append(achievement)
//        }
//
        self.achievements = achievements
    }
    
}
