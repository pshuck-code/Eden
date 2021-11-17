//
//  ProfileViewViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 7/13/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewViewController: UIViewController {

    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var groupButton: UIButton!
    
    //let home = HomeViewController()
    var posts = [Post]()
    //var messenger = MessagingViewController()
    
    let userDefaults = UserDefaults.standard
    var indexNum = UserDefaults.standard.integer(forKey: "index")
    var nameHold = UserDefaults.standard.string(forKey: "user")
    var photoUrl = UserDefaults.standard.url(forKey: "url")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeView.layer.shadowColor = UIColor.lightGray.cgColor
        welcomeView.layer.shadowOpacity = 1
        welcomeView.layer.shadowOffset = .init(width: 0, height: 1)
        welcomeView.layer.shadowRadius = 1
        welcomeView.layer.cornerRadius = 15
        
        groupButton.layer.cornerRadius = 15
        
        userDefaults.set(0, forKey: "index")
        username.text = nameHold
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        
        self.profileImageView.image = nil
        ImageService.getImage(withURL: photoUrl!) { image, url in
            guard let _post = self.post else { return }
            if _post.author.photoURL.absoluteString == url.absoluteString {
                self.profileImageView.image = image
            } else {
                //handle some error
                print("Not the right image")
            }
        }//end of .downloadImage
        
    }//end of viewDidLoad
    
    weak var post:Post?
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }//end of func
    
    func set(post:Post) {
        self.post = post
        
        //self.profileImageViewPic.image = nil
            ImageService.getImage(withURL: post.author.photoURL) { image, url in
                guard let _post = self.post else { return }
                if _post.author.photoURL.absoluteString == url.absoluteString {
          //          self.profileImageViewPic.image = image
                } else {
                    //handle some error
                    print("Not the right image")
                }
            }//end of .downloadImage
         //   username.text = post.author.username
        }//end of func

    }
