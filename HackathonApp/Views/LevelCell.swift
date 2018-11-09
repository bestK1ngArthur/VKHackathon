//
//  LevelCell.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class LevelCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var achievements: [Achievement] = [] {
        didSet {
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
                self.cellsAchievements = achs
            } else {
                self.cellsAchievements = achievements
            }
            
        }
    }
    var cellsAchievements: [Achievement] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsAchievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AchievementCell.self), for: indexPath) as? AchievementCell
        
        cell?.fillCell(achievement: cellsAchievements[indexPath.row])
        
        return cell ?? UICollectionViewCell()
    }
}
