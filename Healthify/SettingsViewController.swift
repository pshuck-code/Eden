//
//  SettingsViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 4/24/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import FirebaseAuth
class SettingsViewController: UIViewController {

    @IBOutlet weak var homeLayer: UIView!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutButton.layer.cornerRadius = 10
        
        let lay = CAGradientLayer()
        lay.frame = view.bounds
        lay.colors = [UIColor.systemGreen.cgColor, UIColor.green.cgColor]
        lay.startPoint = CGPoint(x: 0, y: 0)
        lay.endPoint = CGPoint(x: 0, y:3 )
        homeLayer.layer.addSublayer(lay)
        homeLayer.layer.insertSublayer(lay, at: 0)
       
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }//do
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }//catch
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }//LogOut
    
    
}//end of program
