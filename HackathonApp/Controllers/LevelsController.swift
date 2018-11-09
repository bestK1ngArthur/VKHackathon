//
//  LevelsController.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class LevelsController: UITableViewController {

    var achievements: [Achievement] = [Achievement(title: "ТЕСТ", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1, isCompleted: false), Achievement(title: "A", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1.3, isCompleted: false), Achievement(title: "B", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1.1, isCompleted: false), Achievement(title: "C", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 2.6, isCompleted: false), Achievement(title: "D", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 4, isCompleted: false)]
    var levels: [Level] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.levels = LevelsContainer(achievements: achievements).levels
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let level = levels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LevelCell.self), for: indexPath) as? LevelCell
        
        cell?.titleLabel.text = level.title
        cell?.achievements = level.achievements
        
        return cell ?? UITableViewCell()
    }
}

