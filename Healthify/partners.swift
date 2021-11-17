//
//  partners.swift
//  Healthify
//
//  Created by Parker Shuck on 5/4/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit

class partners: UIViewController {

    @IBOutlet weak var homeLayer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var instaButton: NSLayoutConstraint!
    
    @IBOutlet weak var igButton: UIButton!
    @IBOutlet weak var ytButton: UIButton!
    @IBOutlet weak var twiButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lay = CAGradientLayer()
        lay.frame = view.bounds
        lay.colors = [UIColor.systemGreen.cgColor, UIColor.green.cgColor]
        lay.startPoint = CGPoint(x: 0, y: 0)
        lay.endPoint = CGPoint(x: 0, y:3 )
        homeLayer.layer.addSublayer(lay)
        homeLayer.layer.insertSublayer(lay, at: 0)
        
        fbButton.layer.cornerRadius = 10
        igButton.layer.cornerRadius = 10
        ytButton.layer.cornerRadius = 10
        twiButton.layer.cornerRadius = 10
    }//end of viewDidLoad
    
    @IBOutlet weak var closeOut: UIView!

    @IBAction func closeView(_ sender: Any) {
     self.dismiss(animated: true, completion: nil)
    }//end of function
    
    @IBAction func igButtonClick(_ sender: Any) {
        let appURL = URL(string: "instagram://user?username=yourUSERNAME")!//fix this
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL)
        {
            application.open(appURL)
        }
        else
        {
            let webURL = URL(string: "https://instagram.com/yourUSERNAME")!//fix this
            application.open(webURL)
        }
    }//end of igButtonClick
    
    @IBAction func fbButtonClick(_ sender: Any) {
        let appURL = URL(string: "fb://profile/yourUSERNAME")!//fix this
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL)
        {
            application.open(appURL)
        }
        else
        {
            let webURL = URL(string: "https://www.facebook.com/yourUSERNAME")!//fix this
            application.open(webURL)
        }
    }//end of fbButtonClick
    
    @IBAction func twitterButtonClicked(_ sender: Any) {
        let appURL = URL(string: "twitter://user?screen_name=yourUSERNAME")!//fix this
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL)
        {
            application.open(appURL)
        }
        else
        {
            let webURL = URL(string: "https://twitter.com/yourUSERNAME")!//fix this
            application.open(webURL)
        }
    }//end of twitterButtonClicked
    
    @IBAction func youtubeButtonClicked(_ sender: Any) {
        let appURL = URL(string: "youtube://user?screen_name=yourUSERNAME")!//fix this
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL)
        {
            application.open(appURL)
        }
        else
        {
            let webURL = URL(string: "https://youtube.com/yourUSERNAME")!//fix this
            application.open(webURL)
        }
    }
    

}
