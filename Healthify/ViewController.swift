//
//  ViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 4/19/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet var homeLayer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 4
        loginButton.layer.cornerRadius = 4
    /*
        let lay = CAGradientLayer()
        lay.frame = view.bounds
        lay.colors = [UIColor.systemGreen.cgColor, UIColor.green.cgColor]
        lay.startPoint = CGPoint(x: 0, y: 0)
        lay.endPoint = CGPoint(x: 0, y:3 )
        homeLayer.layer.addSublayer(lay)
        homeLayer.layer.insertSublayer(lay, at: 0) */
    }
    
    @IBAction func goToSuPage(_ sender: Any) {
        performSegue(withIdentifier: "segueOne", sender: self)
    }

    @IBAction func goToSuLoPage(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
            if let user = Auth.auth().currentUser {
                self.performSegue(withIdentifier: "alreadyLoggedIn", sender: self)
            }
        }
}

