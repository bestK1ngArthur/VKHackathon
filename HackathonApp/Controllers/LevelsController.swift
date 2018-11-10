//
//  LevelsController.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class LevelsController: UITableViewController {

    var achievements: [Achievement] = [Achievement(title: "ТЕСТ", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1, isCompleted: false), Achievement(title: "A", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1.3, isCompleted: false), Achievement(title: "B", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1.1, isCompleted: false), Achievement(title: "C", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 2.6, isCompleted: false), Achievement(title: "D", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 4, isCompleted: false), Achievement(title: "1", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1.3, isCompleted: false), Achievement(title: "2", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 0.9, isCompleted: false)]
    var levels: [Level] = []
    var paths: [Path] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let container = LevelsContainer(achievements: achievements)
        
        self.levels = container.levels
        self.paths = container.paths
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let level = levels[indexPath.row]
        let path = paths[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LevelCell.self), for: indexPath) as? LevelCell
        
        cell?.titleLabel.text = level.title
        cell?.achievements = level.achievements
        cell?.path = path
        
        if levels.indices.contains(indexPath.row - 1) {
            cell?.fromAchievements = levels[indexPath.row - 1].achievements
        }
        
        if levels.indices.contains(indexPath.row + 1) {
            cell?.toAchievements = levels[indexPath.row + 1].achievements
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OpenAchievement" {
            let viewController: AchievementController? = (segue.destination as? UINavigationController)?.viewControllers.last as? AchievementController
            
            if let vc = viewController, let cell = sender as? AchievementCell, let ach = cell.achievement  {
                vc.achievement = ach
            }
        }
    }
}

