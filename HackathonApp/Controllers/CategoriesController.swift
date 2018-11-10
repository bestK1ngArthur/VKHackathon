//
//  CategoriesController.swift
//  HackathonApp
//
//  Created by a.belkov on 10/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit
import Alamofire

class CategoriesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    let categories: [(image: UIImage, title: String)] = [(image: UIImage(named: "it_ic")!, title: "Информационные технологии"), (image: UIImage(named: "math_ic")!, title: "Математика"), (image: UIImage(named: "chem_ic")!, title: "Химия"), (image: UIImage(named: "bio_ic")!, title: "Биология"), (image: UIImage(named: "phys_ic")!, title: "Физика"), (image: UIImage(named: "proj_ic")!, title: "Проектная смена")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
    
    @IBAction func signUp(_ sender: Any) {
        self.startActivity()
        
        Alamofire.request("http://95.213.28.140:8080/?method=register&name=\(usernameField.text)&region=Moscow&stream1=X&lvl1=8&stream2=&lvl2=0&stream3=&lvl3=0&stream4=&lvl4=0&stream5=&lvl5=0&stream6=&lvl6=0").responseJSON { response in
            
            self.stopActivity()
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
    }
 
    func startActivity() {
        self.activityView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        self.activityView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}
