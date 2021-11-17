//
//  LoginViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 4/20/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButtonFinal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonFinal.layer.cornerRadius = 4

    }
    
    @IBAction func backFromLo(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
           if error == nil{
             self.performSegue(withIdentifier: "loginToHome", sender: self)
                          }
            else{
             let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
             let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
              alertController.addAction(defaultAction)
              self.present(alertController, animated: true, completion: nil)
                 }
        }
        
    }
    
    
}
