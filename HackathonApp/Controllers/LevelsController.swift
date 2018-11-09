//
//  LevelsController.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class LevelsController: UITableViewController {

    var achievement: [Achievement] = [Achievement(title: "ТЕСТ", description: "ТЕСТ", address: "ТЕСТ", url: nil, isCompleted: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LevelCell.self), for: indexPath) as? LevelCell
        
        cell?.achievements = [achievement[0], achievement[0], achievement[0]]
        
        return cell ?? UITableViewCell()
    }
}

