//
//  HomeViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 4/21/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController  {
    
    @IBOutlet weak var semiCircle: UILabel!
    @IBOutlet var homeLayer: UIView!
    //let transition = CircularTransition()
    @IBOutlet weak var todoView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var analyticsView: UIView!
    @IBOutlet weak var goTodo: UIButton!
    @IBOutlet weak var goTimer: UIButton!
    @IBOutlet weak var goAnalytics: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var welcomeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoView.layer.cornerRadius = 10
        timerView.layer.cornerRadius = 10
        analyticsView.layer.cornerRadius = 10
        welcomeView.layer.cornerRadius = 10

        goTodo.layer.cornerRadius = goTodo.bounds.height/2
        goTimer.layer.cornerRadius = goTodo.bounds.height/2
        goAnalytics.layer.cornerRadius = goTodo.bounds.height/2
        
        todoView.layer.shadowColor = UIColor.lightGray.cgColor
        todoView.layer.shadowOpacity = 1
        todoView.layer.shadowOffset = .init(width: 0, height: 1)
        todoView.layer.shadowRadius = 1
        
        welcomeView.layer.shadowColor = UIColor.lightGray.cgColor
        welcomeView.layer.shadowOpacity = 1
        welcomeView.layer.shadowOffset = .init(width: 0, height: 1)
        welcomeView.layer.shadowRadius = 1
        
        //guard let userProfile = UserService.currentUserProfile else { return print("Hey") }
        
        guard let userProfile = Auth.auth().currentUser?.displayName else { return }
        
         self.greetingLabel.text = "Hello, " + userProfile + "."
      /*  let lay = CAGradientLayer()
        lay.frame = view.bounds
        lay.colors = [UIColor.systemGreen.cgColor, UIColor.green.cgColor]
        lay.startPoint = CGPoint(x: 0, y: 0)
        lay.endPoint = CGPoint(x: 0, y:3 )
        homeLayer.layer.addSublayer(lay)
        homeLayer.layer.insertSublayer(lay, at: 0) */
    }//end of viewDidLoad
    
    override func viewDidLayoutSubviews() {
        //Circle Points
     /*   let center = CGPoint (x: myCircle.frame.size.width / 2, y: myCircle.frame.size.height / 2-135)
        let circleRadius = myCircle.frame.size.width / 2
        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 2), clockwise: false)
        semiCircleLayer.path = circlePath.cgPath
        semiCircleLayer.strokeColor = UIColor.white.cgColor
        semiCircleLayer.fillColor = UIColor.white.cgColor
        semiCircleLayer.lineWidth = 8
        semiCircleLayer.strokeStart = 0
        semiCircleLayer.strokeEnd  = 1
        myCircle.layer.addSublayer(semiCircleLayer)*/
    }//over ride func
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if (partnerButton.isTouchInside) {
            ifPartbut = true
            let secondVC = segue.destination as! partners
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
        }//end of if
    }//end of function
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if(ifSetbut){
        transition.transitionMode = .present
        transition.startingPoint = settingsButton.center
        transition.circleColor = UIColor.systemGreen
        }
        else if(ifPartbut){
        transition.transitionMode = .present
        transition.startingPoint = partnerButton.center
        transition.circleColor = UIColor.systemGreen
        }
        return transition
    }//end of function
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if(ifSetbut){
        transition.transitionMode = .dismiss
        transition.startingPoint = settingsButton.center
        transition.circleColor = UIColor.white
        }
        else if(ifPartbut){
        transition.transitionMode = .dismiss
        transition.startingPoint = partnerButton.center
        transition.circleColor = UIColor.white
        }
        ifPartbut = false
        ifSetbut = false
        return transition
    }//end of function */
  
}//end of class

