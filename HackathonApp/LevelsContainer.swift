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
    private(set) var paths: [Path]
    private let achievements: [Achievement]
        
    init(achievements: [Achievement]) {
        self.achievements = achievements
        self.levels = []
        self.paths = []
        
        self.calculateLevels()
        self.fillLevels()
        self.calculatePaths()
    }
    
    private func calculateLevels() {
        
        let achievements = self.achievements.sorted { (first, second) -> Bool in
            
            if first.complexity.rounded() == second.complexity.rounded() {
                return first.isCompleted
            }
            
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
    
    private func fillLevels() {
        
        var newLevels: [Level] = []
        for level in levels {
            
            let achievements = level.achievements
            var newAchievements: [Achievement] = []
            
            if achievements.count < 3 {
                var lastAchs = achievements
                var achs: [Achievement] = [Achievement.empty, Achievement.empty, Achievement.empty]
                while lastAchs.count > 0  {
                    let position = Int.random(in: 0...2)
                    if achs[position].isEmpty {
                        achs[position] = lastAchs.first!
                        lastAchs.removeFirst()
                    }
                }
                newAchievements = achs
            } else {
                newAchievements = achievements
            }
            
            newLevels.append(Level(title: level.title, achievements: newAchievements))
        }
        
        self.levels = newLevels
    }
    
    private func calculatePaths() {
        
        var paths: [Path] = []
        
        var lastLayer: Layer? = nil
        for (index, level) in levels.enumerated() {
            
            if levels.indices.contains(index+1) {
                let nextLevel = levels[index+1]
                
                let fromIndexes = indexesOfFilledAchievements(level.achievements)
                let toIndexes = indexesOfFilledAchievements(nextLevel.achievements)
                
                let layer = calculateLayer(from: fromIndexes, to: toIndexes)
                
                if let lastLayer = lastLayer {
                    paths.append((from: lastLayer, to: layer))
                } else {
                    paths.append((from: [:], to: layer))
                }
                
                lastLayer = layer
                
            } else if index == (levels.count - 1), let last = lastLayer {
                paths.append((from: last, to: [:]))
            }
        }
        
        self.paths = paths
    }
    
    private func indexesOfFilledAchievements(_ achievements: [Achievement]) -> [Int] {
        
        var achievementsIndexes: [Int] = []
        for (index, achievement) in achievements.enumerated() {
            if !achievement.isEmpty {
                achievementsIndexes.append(index)
            }
        }
        
        return achievementsIndexes
    }
    
    private func calculateLayer(from: [Int], to: [Int]) -> Layer {
        
        var layer: Layer = [:]
        
        var currentFrom = from
        var currentTo = to
        
        while (currentFrom.count > 0) || (currentTo.count > 0) {
            
            if let fromValue = currentFrom.first, currentTo.count > 0 {
                let toIndex = Int.random(in: 0..<currentTo.count)
                
                if layer[fromValue] == nil {
                    layer[fromValue] = []
                }
                
                layer[fromValue]?.append(currentTo[toIndex])
                
                currentFrom.removeFirst()
                
                continue
                
            } else if let toValue = currentTo.first, currentFrom.count > 0 {
                let fromIndex = Int.random(in: 0..<currentTo.count)
                let fromValue = currentFrom[fromIndex]
                
                if layer[fromValue] == nil {
                    layer[fromValue] = []
                }
                
                layer[fromValue]?.append(toValue)
                
                currentTo.removeFirst()
                
                continue
                
            } else {
                break
            }
        }
        
        return layer
    }
}
