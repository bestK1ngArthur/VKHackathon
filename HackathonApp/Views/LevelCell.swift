//
//  LevelCell.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

typealias Layer = [Int: [Int]]
typealias Path = (from: Layer, to: Layer)

enum PointType {
    case from, via, to
}

class LevelCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var drawingView: DrawingView!
    
    var achievements: [Achievement] = [] {
        didSet {
            drawPaths()
        }
    }
    
    var fromAchievements: [Achievement] = [] {
        didSet {
            drawPaths()
        }
    }
    
    var toAchievements: [Achievement] = [] {
        didSet {
            drawPaths()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AchievementCell.self), for: indexPath) as? AchievementCell
        
        cell?.fillCell(achievement: achievements[indexPath.row])
        
        return cell ?? UICollectionViewCell()
    }

    func calculatePaths() -> Path {
        
        // Ниже идёт говнокодик для рисования рёбр графа.
        // Прошу меня простить, но времени на что-то нормальное нет, хакатон всё-таки.
        
        let fromAchs = indexesOfFilledAchievements(fromAchievements)
        let viaAchs = indexesOfFilledAchievements(achievements)
        let toAchs = indexesOfFilledAchievements(toAchievements)
        
        let fromViaLayer = calculateLayer(from: fromAchs, to: viaAchs)
        let viaToLayer = calculateLayer(from: viaAchs, to: toAchs)
        
        return (fromViaLayer, viaToLayer)
    }
    
    func calculateLayer(from: [Int], to: [Int]) -> Layer {
        
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
    
    func drawPaths() {
        
        let paths = calculatePaths()
        self.drawingView.drawPaths(paths)
    }
    
    func indexesOfFilledAchievements(_ achievements: [Achievement]) -> [Int] {
        
        var achievementsIndexes: [Int] = []
        for (index, achievement) in achievements.enumerated() {
            if !achievement.isEmpty {
                achievementsIndexes.append(index)
            }
        }
        
        return achievementsIndexes
    }
}
