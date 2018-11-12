//
//  CategoriesController.swift
//  HackathonApp
//
//  Created by a.belkov on 10/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit
import Alamofire

class CategoriesController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    let categories: [(image: UIImage, title: String)] = [(image: UIImage(named: "it_ic")!, title: "Информационные технологии"), (image: UIImage(named: "math_ic")!, title: "Математика"), (image: UIImage(named: "chem_ic")!, title: "Химия"), (image: UIImage(named: "bio_ic")!, title: "Биология"), (image: UIImage(named: "phys_ic")!, title: "Физика"), (image: UIImage(named: "proj_ic")!, title: "Проектная смена")]
    var selectedCategories: [String: String] = ["Информационные технологии": "",
                                                "Математика": "",
                                                "Химия": "",
                                                "Биология": "",
                                                "Физика": "",
                                                "Проектная смена": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.usernameField.delegate = self
        
        self.stopActivity()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category")
        
        cell?.textLabel?.text = categories[indexPath.row].title
        cell?.imageView?.image = categories[indexPath.row].image
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = categories[indexPath.row].title
        let cell = tableView.cellForRow(at: indexPath)
        
        if let cell = cell {
            selectedCategories[title] = cell.isSelected ? "X" : ""
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        self.startActivity()
        
        let string = "http://95.213.28.140:8080/?method=register&name=\(usernameField.text ?? "")&region=Moscow&stream1=\(selectedCategories["Информационные технологии"]!)&lvl1=8&stream2=\(selectedCategories["Математика"]!)&lvl2=0&stream3=\(selectedCategories["Химия"]!)&lvl3=0&stream4=\(selectedCategories["Биология"]!)&lvl4=0&stream5=\(selectedCategories["Физика"]!)&lvl5=0&stream6=\(selectedCategories["Проектная смена"]!)&lvl6=0"
        let url = URL(string: string)!
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.stopActivity()
            
            AppManager.shared.currentUserName = self.usernameField.text
            
            for (key, value) in self.selectedCategories {
                if value.isEmpty == false {
                    if let category = Achievement.Category(rawValue: key) {
                        AppManager.shared.currentUserCategory = category
                    }
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            self.stopActivity()
            
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
            let dataString = String(data: data, encoding: .utf8)!
            let jsonString = "{\(dataString.split(separator: "{").last!.split(separator: "}").first!)}"
            
            if let jsonData = jsonString.data(using: String.Encoding.utf8) {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
                    
                    if let userID = json?["user_id"] as? Int {
                        AppManager.shared.currentUserID = userID
                        AppManager.shared.currentUserName = self.usernameField.text
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                    
                } catch {
                    print("ERROR")
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        task.resume()
    }
 
    func startActivity() {

        DispatchQueue.main.async {
            self.activityView.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivity() {
        
        DispatchQueue.main.async {
            self.activityView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
