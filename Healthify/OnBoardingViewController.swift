//
//  OnBoardingViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 5/17/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController{
    
    
    @IBOutlet weak var holderView: UIView!
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }//end of viewDidLoad
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }//end of function
    
    private func configure(){
        //sets up scroll view
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        let titles = ["Welcome", "Our Goal", "Environment", "Spread Love", "You're Ready"]
        for x in 0..<5
        {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * (holderView.frame.size.width), y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            //title image button
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width-20, height: 220))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10+120+10, width: pageView.frame.size.width-20, height: pageView.frame.size.height - 60 - 130 - 15))
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height-125, width: pageView.frame.size.width-20, height: 50))
            
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 32)
            pageView.addSubview(label)
            label.text = titles[x]
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "rocket")//get image name
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemGreen
            button.setTitle("Continue", for: .normal)
            if x == 4 {
                button.setTitle("Get Started", for: .normal)
            }//end of if
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x + 1
            pageView.addSubview(button)
        }//end of for
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 3, height: 0)
        scrollView.isPagingEnabled = true
        
    }//end of function
    
    @objc func didTapButton(_ button: UIButton){
        guard button.tag < 5 else{
            //dismiss
           // dismiss(animated: true, completion: nil)
            segueToHome()
            return
        }//end of else
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }//end of function
    
    func segueToHome(){
        performSegue(withIdentifier: "goHome", sender: nil)
    }//end of func
   
    
}//end of class


