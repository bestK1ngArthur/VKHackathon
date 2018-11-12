//
//  CharacterViewController.swift
//  HackathonApp
//
//  Created by a.belkov on 09/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit
import VK_ios_sdk

class CharacterViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var levelValueLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var levelProgressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let loadingImages = (0...4).map { UIImage(named: "chemistry_\($0)")! }
//
//        self.characterImageView.animationImages = loadingImages
//        self.characterImageView.animationDuration = 1.0
//        self.characterImageView.startAnimating()
        
        self.characterImageView.image = AppManager.shared.characterImage
        self.levelProgressLabel.isHidden = true
        
        self.stopActivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.characterImageView.image = AppManager.shared.characterImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let oldLevel = AppManager.shared.currentUserLevel
        AppManager.shared.updateUserLevel()
        let newLevel = AppManager.shared.currentUserLevel
        
        if oldLevel < 5 {
            self.characterImageView.image = AppManager.shared.characterImage
        }
        
        self.levelValueLabel.text = "\(Int(oldLevel))"
        self.levelProgressLabel.text = "\(Int(oldLevel) % 10)/10"
        
        let delta = Float(Double(Int(newLevel)) - oldLevel)
        
        if Int(newLevel) != Int(oldLevel) {
            UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                
                self.levelValueLabel.text = "\(Int(newLevel))"
                self.levelProgressLabel.text = "\(Int(newLevel) % 10)/10"
                self.levelValueLabel.transform = self.levelValueLabel.transform.scaledBy(x: 1.5, y: 1.5)
                
                self.characterImageView.alpha = 0
                self.characterImageView.transform = self.characterImageView.transform.scaledBy(x: 1.5, y: 1.5)

            }, completion: { _ in
                
                if newLevel < 5 {
                    self.characterImageView.image = AppManager.shared.characterImage
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
    
    @IBAction func share(_ sender: Any) {
        
        let permissions = [VK_PER_WALL, VK_PER_PHOTOS]
        
        VKSdk.wakeUpSession(permissions) { (state, error) in
            
            if state != .authorized {
                VKSdk.authorize(permissions)
            } else {
                
                guard let photo = self.characterImageView.image else {
                    return
                }
                
                let photoRequest = VKApi.uploadAlbumPhotoRequest(photo, parameters: VKImageParameters.jpegImage(withQuality: 0.5), albumId: 260334342, groupId: 0)
                
                self.startActivity()
                photoRequest?.execute(resultBlock: { response in
                    guard let response = response else { return }

                    let photo: VKPhoto = (response.parsedModel as! VKPhotoArray)[0]
                    let photoAttachment = "\(photo.owner_id!)_\(photo.id!)"
                    
                    self.stopActivity()
                    
                    let dialog = VKShareDialogController()
                    dialog.dismissAutomatically = true
                    dialog.text = "Зацените какой-крутой у меня персонаж в Sirius.Connect 😍"
                    dialog.vkImages = [photoAttachment]
                    dialog.completionHandler = { (result, _) in
                        print(result)
                    }
                    
                    self.present(dialog, animated: true, completion: nil)

                }, errorBlock: { error in
                    print(error)
                    
                    self.stopActivity()
                })
            }
        }
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
}

