//
//  CharacterViewController.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loadingImages = (0...4).map { UIImage(named: "chemistry_\($0)")! }
        
        self.characterImageView.animationImages = loadingImages
        self.characterImageView.animationDuration = 1.0
        self.characterImageView.startAnimating()
    }
}

