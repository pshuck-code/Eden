//
//  TimerViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 6/29/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class TimerViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    @IBOutlet weak var resetOutlet: UIButton!
    @IBOutlet weak var continueOutlet: UIButton!
    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var secondsLabel: UILabel!
    var timerNum = 0
    
    let TodoRef = TodoListViewController()
    
    var dayNum = UserDefaults.standard.integer(forKey: "number")
    var currDay = UserDefaults.standard.integer(forKey: "day")
    var timerHolder = UserDefaults.standard.integer(forKey: "timer")
    let userDefaults = UserDefaults.standard
    
    var timerGoing = false
    var seconds = 60
    var minutes = 24
    var timer = Timer()
    var audioPlayer = AVAudioPlayer()
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    var animeTime = 1500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.set(0, forKey: "number")
        userDefaults.set(TodoRef.getDate(0), forKey: "day")
        userDefaults.set(0, forKey: "task")
        
        dayNum = userDefaults.integer(forKey: "number")
        currDay = userDefaults.integer(forKey: "day")
        timerHolder = userDefaults.integer(forKey: "timer")
        
        audioPlayer.delegate = self
        startOutlet.layer.cornerRadius = startOutlet.bounds.height/2
        stopOutlet.layer.cornerRadius = stopOutlet.bounds.height/2
        resetOutlet.layer.cornerRadius = resetOutlet.bounds.height/2
        continueOutlet.layer.cornerRadius = continueOutlet.bounds.height/2
        
        introView.layer.shadowColor = UIColor.lightGray.cgColor
        introView.layer.shadowOpacity = 1
        introView.layer.shadowOffset = .init(width: 0, height: 1)
        introView.layer.shadowRadius = 1
        introView.layer.cornerRadius = 10
        
        startOutlet.backgroundColor = UIColor.white
        stopOutlet.backgroundColor = UIColor.white
        resetOutlet.backgroundColor = UIColor.white
        continueOutlet.backgroundColor = UIColor.white
        
        startOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        startOutlet.layer.shadowOpacity = 1
        startOutlet.layer.shadowOffset = .init(width: 0, height: 1)
        startOutlet.layer.shadowRadius = 1
        
        stopOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        stopOutlet.layer.shadowOpacity = 1
        stopOutlet.layer.shadowOffset = .init(width: 0, height: 1)
        stopOutlet.layer.shadowRadius = 1
        
        resetOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        resetOutlet.layer.shadowOpacity = 1
        resetOutlet.layer.shadowOffset = .init(width: 0, height: 1)
        resetOutlet.layer.shadowRadius = 1
        
        continueOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        continueOutlet.layer.shadowOpacity = 1
        continueOutlet.layer.shadowOffset = .init(width: 0, height: 1)
        continueOutlet.layer.shadowRadius = 1
        
        resetOutlet.isHidden = true
        continueOutlet.isHidden = true
        stopOutlet.isHidden = true
        
        do{
            let audioPath = Bundle.main.path(forResource: "alarm", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch{
            //error
        }
    }//end of viewDidLoad
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //set the current time here
        audioPlayer.currentTime = 0
    }//end of func
    
    @IBAction func startButton(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.counter), userInfo: nil, repeats: true)
        audioPlayer.currentTime = 0
        timerGoing = true
        startOutlet.isHidden = true
        stopOutlet.isHidden = false
        resetOutlet.isHidden = false
        continueOutlet.isHidden = true
    }//end of startButton
    
    @objc func counter (){
        seconds -= 1
        animeTime -= 1
        
        if seconds == 0{
            minutes -= 1
            seconds = 59
        }//end of if
        
        secondsLabel.text = String(seconds)
        label.text = String(minutes)
        
        if (minutes == 0){
            timer.invalidate()
            audioPlayer.play()
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let refTwo = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(self.TodoRef.getDate(0)))
            refTwo.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let username = value?["timer"] as? Int ?? 0
                self.timerNum = Int(username)
                print("username is", username)
                 print("timerNum is", self.timerNum)
                self.timerNum = self.timerNum + 1
                print(self.timerNum)
                refTwo.child("timer").setValue(self.timerNum)
                
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
            
            if TodoRef.currDay == TodoRef.getDate(0){
                timerHolder += 1
            }//end of if
            else{
                TodoRef.currDay = TodoRef.getDate(0)
                timerHolder = 1
            }//end of else
             
            
            
        }//end of if
    }//end of func
    
    @IBAction func stopButton(_ sender: Any) {
        timer.invalidate()
        label.text = String(minutes)
        timerGoing = false
        continueOutlet.isHidden = false
        audioPlayer.stop()
    }//end of func
    
    @IBAction func exit(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }//end of func
    
    @IBAction func resetButton(_ sender: Any) {
        timer.invalidate()
        label.text = String(minutes)
        animeTime = 1500
        seconds = 60
        audioPlayer.stop()
        startOutlet.isHidden = false
        resetOutlet.isHidden = true
        continueOutlet.isHidden = true
        stopOutlet.isHidden = true
        timerGoing = false
        label.text = "25"
        secondsLabel.text = "00"
    }//end of func
    
    @IBAction func continueButton(_ sender: Any) {
        if timerGoing == false {
            timerGoing = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.counter), userInfo: nil, repeats: true)
            continueOutlet.isHidden = true
        }//end of if
       
    }//end of func
    
    func remove(){
        self.view.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
    }
    
}//end of class

@IBDesignable
public class CircularProgressView: UIView {

    @IBInspectable var duration:  CFTimeInterval = 10
    @IBInspectable var lineWidth: CGFloat = 1  { didSet { updatePaths() } }

    private(set)   var isRunning = false
    private        var elapsed: CFTimeInterval = 0
    private        var startTime: CFTimeInterval!
    private        let animationKey = Bundle.main.bundleIdentifier! + ".strokeEnd"

    private let backgroundShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.tertiarySystemGroupedBackground.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    
    private let progressShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        return shapeLayer
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
    }
    
    public override func prepareForInterfaceBuilder() {
        progressShapeLayer.strokeEnd = 1 / 3
    }
    
    @IBAction func pauseButton(_ sender: Any) {
        pause()
    }
    
    @IBAction func startButton(_ sender: Any) {
        start(duration: 1500)
    }
    
    @IBAction func continueButton(_ sender: Any) {
        resume()
    }
    
    @IBAction func resetButton(_ sender: Any) {
        reset()
    }
}//end of class

public extension CircularProgressView {
    func start(duration: CFTimeInterval) {
        self.duration = duration
        reset()
        resume()
    }
    
    func pause() {
        guard
            isRunning,
            let presentation = progressShapeLayer.presentation()
        else {
            return
        }
        
        elapsed += CACurrentMediaTime() - startTime
        progressShapeLayer.strokeEnd = presentation.strokeEnd
        progressShapeLayer.removeAnimation(forKey: animationKey)
    }
    
    func resume() {
        guard !isRunning else { return }
        
        isRunning = true
        startTime = CACurrentMediaTime()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = elapsed / duration
        animation.toValue = 1
        animation.duration = duration - elapsed
        animation.delegate = self
        progressShapeLayer.strokeEnd = 1
        progressShapeLayer.add(animation, forKey: animationKey)
    }
    
    func reset() {
        isRunning = false
        progressShapeLayer.removeAnimation(forKey: animationKey)
        progressShapeLayer.strokeEnd = 0
        elapsed = 0
    }
}//end of extension

extension CircularProgressView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isRunning = false
    }
}//end of extension

private extension CircularProgressView {
    func configure() {
        layer.addSublayer(backgroundShapeLayer)
        layer.addSublayer(progressShapeLayer)
    }
    
    func updatePaths() {
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2.5
        let center = CGPoint(x: bounds.midX, y: bounds.midY + (bounds.midY/11))
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        
        backgroundShapeLayer.lineWidth = 5
        progressShapeLayer.lineWidth = 5
        
        backgroundShapeLayer.path = path.cgPath
        progressShapeLayer.path = path.cgPath
    }
}//end of extension
