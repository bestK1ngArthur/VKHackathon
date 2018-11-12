//
//  LevelsController.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class LevelsController: UITableViewController {

    var achievements: [Achievement] = [Achievement(title: "ТЕСТ", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1, isCompleted: false, category: .chem), Achievement(title: "A", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1.3, isCompleted: false, category: .it), Achievement(title: "B", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1.1, isCompleted: false, category: .proj), Achievement(title: "C", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 2.6, isCompleted: false, category: .math), Achievement(title: "D", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 4, isCompleted: false, category: .bio), Achievement(title: "1", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 1.3, isCompleted: false, category: .phys), Achievement(title: "2", description: "ТЕСТ", address: "ТЕСТ", url: nil, complexity: 0.9, isCompleted: false, category: .chem)]
    var levels: [Level] = []
    var paths: [Path] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.achievements = AppManager.shared.userAchievements
        
        let container = LevelsContainer(achievements: achievements)
        
        self.levels = container.levels
        self.paths = container.paths
        
        printPaths()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        self.tableView.register(UINib(nibName: "LevelCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AppManager.shared.needToUpdateLevels {
            
            self.achievements = AppManager.shared.userAchievements
            
            let container = LevelsContainer(achievements: achievements)
            
            self.levels = container.levels
            self.paths = container.paths
            
            AppManager.shared.needToUpdateLevels = false
            
            self.updateTable()
        }
    }
    
    func printPaths() {
        
        for path in self.paths {
            
            var string = "from: ("
            for el in path.from.keys {
                string += "\(el) -> ("
                path.from[el]?.forEach({ (val) in
                    string += "\(val),"
                })
                string.removeLast()
                string += ") ,"
            }
            
            string.removeLast()
            string.removeLast()

            string += "\nto: ("
            for el in path.to.keys {
                string += "\(el) -> ("
                path.to[el]?.forEach({ (val) in
                    string += "\(val),"
                })
                string.removeLast()
                string += "), "
            }
            
            string.removeLast()
            string.removeLast()
            string += ")"
            
            print(string)
        }
    }
    
    @objc func refreshData(refreshControl: UIRefreshControl) {

        let string = "http://95.213.28.140:8080/?method=get_personal_events&user_id=\(AppManager.shared.currentUserID ?? 1)"
        let url = URL(string: string)!
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {

            let container = LevelsContainer(achievements: self.achievements)
            
            self.levels = container.levels
            self.paths = container.paths

            self.updateTable()
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        
            let dataString = String(data: data, encoding: .utf8)!
            
            if dataString.isEmpty {
                self.updateTable()
                return
            }
            
            let jsonString = "{\(dataString.split(separator: "{").last!.split(separator: "}").first!)}"
            
            if let jsonData = jsonString.data(using: String.Encoding.utf8) {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
                    
//                    if let userID = json?["user_id"] as? Int {
//                        AppManager.shared.currentUserID = userID
//                        AppManager.shared.currentUserName = self.usernameField.text
//                    }
                    
                } catch {
                    print("ERROR")
                }
                
            }

            self.updateTable()
        }
        
        task.resume()
    }
    
    func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let level = levels[indexPath.row]
        let path = paths[indexPath.row]

        let cell = Bundle.main.loadNibNamed("LevelCell", owner: nil, options: nil)?.first as? LevelCell
                
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LevelCell.self), for: indexPath) as? LevelCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LevelCell.self)) as? LevelCell
        
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "OpenAchievement" {
            
            if let cell = sender as? AchievementCell, let ach = cell.achievement  {
                return !ach.isEmpty
            }
        }
        
        return true
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

