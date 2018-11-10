//
//  AchievementCell.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class AchievementCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var achievement: Achievement?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundView.layer.cornerRadius = roundView.frame.height / 2
    }
    
    func fillCell(achievement: Achievement) {
        
        if achievement.isEmpty == false {
            roundView.isHidden = false
            titleLabel.text = String(achievement.title.prefix(1))
        } else {
            roundView.isHidden = true
        }
        
        self.achievement = achievement
        
        //let categoryImage = achievement.categoryImage?.withRenderingMode(.alwaysTemplate)
        //self.imageView.tintColor = UIColor.white
        //self.imageView.image = categoryImage
        
        self.imageView.image = achievement.categoryImage
    }
    
    override func prepareForReuse() {
        roundView.isHidden = false
    }
}
