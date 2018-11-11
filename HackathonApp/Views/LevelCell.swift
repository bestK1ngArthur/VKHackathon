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
//            drawPaths()
        }
    }
    
    var fromAchievements: [Achievement] = [] {
        didSet {
//            drawPaths()
        }
    }
    
    var toAchievements: [Achievement] = [] {
        didSet {
//            drawPaths()
        }
    }
    
    var path: Path = (from: [:], to: [:]) {
        didSet {
            drawPaths()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "AchievementCell", bundle: nil), forCellWithReuseIdentifier: "AchievementCell")
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
        
        //let paths = calculatePaths()
        let path = self.path
        self.drawingView.drawPaths(path)
        
        self.setNeedsDisplay()
        self.layoutIfNeeded()
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
    
    override func prepareForReuse() {
        self.achievements.removeAll()
        self.toAchievements.removeAll()
        self.fromAchievements.removeAll()
        self.path = (from: [:], to: [:])
        
        self.drawPaths()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ach = achievements[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AchievementController") as? UINavigationController
        
        let achVC = controller?.viewControllers.last as? AchievementController
        achVC?.achievement = ach
        
        if let topController = UIApplication.topViewController(), let vc = controller, !ach.isEmpty  {
            topController.present(vc, animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
