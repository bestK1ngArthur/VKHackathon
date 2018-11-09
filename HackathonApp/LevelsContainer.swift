//
//  LevelsContainer.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Foundation

class LevelsContainer {

    private(set) var levels: [Level]
    private let achievements: [Achievement]
    
    init(achievements: [Achievement]) {
        self.achievements = achievements
        self.levels = []
        
        self.calculateLevels()
    }
    
    private func calculateLevels() {
        
        let achievements = self.achievements.sorted { (first, second) -> Bool in
            return first.complexity < second.complexity
        }
        
        var currentComplexityLevel: Int = Int(achievements.first?.complexity.rounded() ?? 0)
        var currentAchievements: [Achievement] = []
        
        for (index, achievement) in achievements.enumerated() {
            
            let achievementComplexity = Int(achievement.complexity.rounded())
            
            if achievementComplexity == currentComplexityLevel {
                currentAchievements.append(achievement)
            } else {
                addLevel(for: currentAchievements, with: currentComplexityLevel)
                currentAchievements = [achievement]
                currentComplexityLevel = achievementComplexity
            }
            
            if index == (achievements.count - 1) {
                addLevel(for: currentAchievements, with: currentComplexityLevel)
                currentAchievements = [achievement]
                currentComplexityLevel = achievementComplexity
            }
        }
    }
    
    private func addLevel(for achievements: [Achievement], with complexityLevel: Int) {
        
        var levels: [Level] = []
        var complexitiyAchievements = achievements

        while complexitiyAchievements.count > 0 {
         
            var count = Int.random(in: 1...3)
            for _ in 0..<count {
                
                if complexitiyAchievements.count <= 0 {
                    break
                }
                
                if complexitiyAchievements.count < count {
                    count = complexitiyAchievements.count
                }
                
                let title: String? = (levels.count == 0) ? "\(complexityLevel) уровень" : nil
                levels.append(Level(title: title, achievements: Array(complexitiyAchievements.prefix(count))))
                
                for _ in 0..<count {
                    complexitiyAchievements.removeFirst()
                }
            }
        }
        
        self.levels.append(contentsOf: levels)
    }
}
