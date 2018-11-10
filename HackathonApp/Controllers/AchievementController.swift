//
//  AchievementController.swift
//  HackathonApp
//
//  Created by a.belkov on 10/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class AchievementController: UITableViewController {

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var completedView: UIView!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var markButton: UIButton!
    
    var achievement: Achievement?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Аааааааа, времени мало осталось((
        
        if let achievement = achievement {
            titleLabel.text = achievement.title
            descriptionLabel.text = achievement.description
            addressLabel.text = achievement.address
            slider.setValue(Float(achievement.complexity), animated: true)
            urlLabel.text = achievement.url?.absoluteString
            typeImageView.image = achievement.categoryImage
            completedView.isHidden = !achievement.isCompleted
            
            goButton.isEnabled = !achievement.isCompleted
            
            if achievement.isCompleted {
                goButton.isEnabled = false
                goButton.backgroundColor = UIColor.lightGray
                goButton.setTitle("Награда получена", for: .normal)
                markButton.isHidden = true
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goAction(_ sender: Any) {
    }
    
    @IBAction func markAction(_ sender: Any) {
    }
}
