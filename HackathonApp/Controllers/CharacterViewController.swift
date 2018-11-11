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
    @IBOutlet weak var levelValueLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let loadingImages = (0...4).map { UIImage(named: "chemistry_\($0)")! }
//
//        self.characterImageView.animationImages = loadingImages
//        self.characterImageView.animationDuration = 1.0
//        self.characterImageView.startAnimating()
        
        self.characterImageView.image = UIImage(named: "chemistry_2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let oldLevel = AppManager.shared.currentUserLevel
        AppManager.shared.updateUserLevel()
        let newLevel = AppManager.shared.currentUserLevel
        
        if oldLevel < 5 {
            self.characterImageView.image = UIImage(named: "chemistry_\(Int(oldLevel))")
        }
        
        self.levelValueLabel.text = "\(Int(oldLevel))"
        
        let delta = Float(newLevel - oldLevel)
        
        if Int(newLevel) != Int(oldLevel) {
            UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
                self.levelValueLabel.text = "\(Int(newLevel))"
                self.levelValueLabel.transform = self.levelValueLabel.transform.scaledBy(x: 1.5, y: 1.5)
                
                self.characterImageView.alpha = 0
                self.characterImageView.transform = self.characterImageView.transform.scaledBy(x: 1.5, y: 1.5)

            }, completion: { _ in
                
                if newLevel < 5 {
                    self.characterImageView.image = UIImage(named: "chemistry_\(Int(newLevel))")
                }
                
                UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                   
                    self.levelValueLabel.transform = CGAffineTransform.identity
                   
                    self.characterImageView.alpha = 1
                    self.characterImageView.transform = CGAffineTransform.identity
                    
                }, completion: nil)
            })
            
            self.progressView.setProgress(delta, animated: true)
        } else {
            self.progressView.setProgress(delta, animated: false)
        }
    }
}

