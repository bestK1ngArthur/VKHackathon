//
//  AddAchievementController.swift
//  HackathonApp
//
//  Created by a.belkov on 10/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class AddAchievementController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var complexitySlider: UISlider!
    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet weak var categoriesPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ААААААААА, нихрена не успеваем
        
        self.categoriesPicker.dataSource = self;
        self.categoriesPicker.delegate = self;
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        // Добавляем на сервер
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppManager.shared.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppManager.shared.categories[row].title

    }
}
