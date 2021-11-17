//
//  AnalyticsViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 7/6/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import Charts
import Firebase

class AnalyticsViewController: UIViewController, ChartViewDelegate {

    var barChart = BarChartView()
    var pieChart = PieChartView()
    var lineChart = LineChartView()
    var combinedChart = CombinedChartView()
    var circleColors : [NSUIColor] = [UIColor.lightGray]
    
    
    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var comboView: UIView!
    
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var sunday: UIButton!
    
    let timerNum = TimerViewController()
    let taskNum = TodoListViewController()
    
    var pieOne: Int?
    var pieTwo: Int?
    
    
    var xOne = 0
    var xTwo = 0
    var xThree = 0
    var xFour = 0
    var xFive = 0
    var xSix = 0
    var xSeven = 0
    var yOne = 0
    var yTwo = 0
    var yThree = 0
    var yFour = 0
    var yFive = 0
    var ySix = 0
    var ySeven = 0
    
    var dataTwoT = PieChartData()
    var setTwo = PieChartDataSet()
    let noDataLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barChart.delegate = self
        pieChart.delegate = self
        lineChart.delegate = self
        combinedChart.delegate = self
        
        pieTwo = Int(timerNum.timerHolder)
        pieOne = Int(taskNum.taskHolder)
        
        noDataLabel.text = "No Data Available"
        noDataLabel.center = bottomContainer.center
        
        introView.layer.shadowColor = UIColor.lightGray.cgColor
        introView.layer.shadowOpacity = 1
        introView.layer.shadowOffset = .init(width: 0, height: 1)
        introView.layer.shadowRadius = 1
        introView.layer.cornerRadius = 10
        
        bottomContainer.layer.shadowColor = UIColor.lightGray.cgColor
        bottomContainer.layer.shadowOpacity = 1
        bottomContainer.layer.shadowOffset = .init(width: 0, height: 1)
        bottomContainer.layer.shadowRadius = 1
        bottomContainer.layer.cornerRadius = 10
        
        comboView.layer.shadowColor = UIColor.lightGray.cgColor
        comboView.layer.shadowOpacity = 1
        comboView.layer.shadowOffset = .init(width: 0, height: 1)
        comboView.layer.shadowRadius = 1
        comboView.layer.cornerRadius = 10
        
       xData(n: 0)
       xData(n: 1)
       xData(n: 2)
       xData(n: 3)
       xData(n: 4)
       xData(n: 5)
       xData(n: 6)
        
       yData(n: 0)
       yData(n: 1)
       yData(n: 2)
       yData(n: 3)
       yData(n: 4)
       yData(n: 5)
       yData(n: 6)
        
       monday.layer.cornerRadius = 10
        tuesday.layer.cornerRadius = 10
        wednesday.layer.cornerRadius = 10
        thursday.layer.cornerRadius = 10
        friday.layer.cornerRadius = 10
        saturday.layer.cornerRadius = 10
        sunday.layer.cornerRadius = 10
        
        monday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        tuesday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        wednesday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        thursday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        friday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        saturday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        sunday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        
        sunday.backgroundColor = UIColor.white
        sunday.setTitleColor(UIColor.systemGreen, for: .normal)
        sunday.layer.shadowColor = UIColor.lightGray.cgColor
        sunday.layer.shadowOpacity = 1
        sunday.layer.shadowOffset = .init(width: 0, height: 1)
        sunday.layer.shadowRadius = 1
        
        monday.setTitle(String(retDate(n: 6)), for: .normal)
        tuesday.setTitle(String(retDate(n: 5)), for: .normal)
        wednesday.setTitle(String(retDate(n: 4)), for: .normal)
        thursday.setTitle(String(retDate(n: 3)), for: .normal)
        friday.setTitle(String(retDate(n: 2)), for: .normal)
        saturday.setTitle(String(retDate(n: 1)), for: .normal)
        sunday.setTitle(String(retDate(n: 0)), for: .normal)
        
    }//end of viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        setInitData()
    }//end of func
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let refTwo = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child("timer")
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child("tasks")
        
        combinedChart.frame = CGRect(x: (self.view.frame.size.width - self.comboView.frame.size.width)/2, y: (self.view.frame.size.height/2)-(self.comboView.frame.size.height/4.55), width: self.comboView.frame.size.width, height: self.comboView.frame.size.height)
        
        view.addSubview(combinedChart)
        
        let setLine = LineChartDataSet(entries: [
            ChartDataEntry(x: Double(retDate(n: 6)), y: Double(ySeven)),
            ChartDataEntry(x: Double(retDate(n: 5)), y: Double(ySix)),
            ChartDataEntry(x: Double(retDate(n: 4)), y: Double(yFive)),
            ChartDataEntry(x: Double(retDate(n: 3)), y: Double(yFour)),
            ChartDataEntry(x: Double(retDate(n: 2)), y: Double(yThree)),
            ChartDataEntry(x: Double(retDate(n: 1)), y: Double(yTwo)),
            ChartDataEntry(x: Double(retDate(n: 0)), y: Double(yOne)),
        ])
        
        let set = BarChartDataSet(entries: [
            BarChartDataEntry(x: Double(retDate(n: 6)), y: Double(xSeven)),
            BarChartDataEntry(x: Double(retDate(n: 5)), y: Double(xSix)),
            BarChartDataEntry(x: Double(retDate(n: 4)), y: Double(xFive)),
            BarChartDataEntry(x: Double(retDate(n: 3)), y: Double(xFour)),
            BarChartDataEntry(x: Double(retDate(n: 2)), y: Double(xThree)),
            BarChartDataEntry(x: Double(retDate(n: 1)), y: Double(xTwo)),
            BarChartDataEntry(x: Double(retDate(n: 0)), y: Double(xOne)),
        ])
        
        set.setColor(UIColor.systemGreen)
        setLine.setColors(UIColor.lightGray)
        setLine.circleColors = circleColors
        
        let lineData = LineChartData(dataSet: setLine)
        let data = BarChartData(dataSet: set)
        
        lineChart.data = lineData
        barChart.data = data
        
        var xValues = [Double(retDate(n: 6)),Double(retDate(n: 5)),Double(retDate(n: 4)),Double(retDate(n: 3)),Double(retDate(n: 2)),Double(retDate(n: 1)),Double(retDate(n: 0))]
        
        let dataTwo: CombinedChartData = CombinedChartData(dataSets: [setLine, set])
        dataTwo.barData = data
        dataTwo.lineData = lineData
        combinedChart.data = dataTwo
        
        combinedChart.leftAxis.drawLabelsEnabled = false
        combinedChart.rightAxis.drawLabelsEnabled = false
        combinedChart.xAxis.drawGridLinesEnabled = false
        combinedChart.drawBordersEnabled = false
        combinedChart.rightAxis.enabled = false
        combinedChart.leftAxis.enabled = false
        combinedChart.xAxis.enabled = false
        combinedChart.backgroundColor = UIColor.clear
        combinedChart.legend.enabled = false
        
        
        pieChart.frame = CGRect(x: self.view.frame.size.width/4.5, y: self.view.frame.size.width * 1.5, width: self.view.frame.size.width/1.75, height: self.view.frame.size.width/1.75)
        
               view.addSubview(pieChart)

                setTwo = PieChartDataSet(entries: [
               
                    PieChartDataEntry(value: Double(pieOne!), data: pieOne),
                    PieChartDataEntry(value: Double(pieTwo!), data: pieTwo),
            
               ])
               //setTwo.removeAll()
               setTwo.setColors(UIColor.systemGreen, UIColor.lightGray)
               dataTwoT = PieChartData(dataSet: setTwo)
               pieChart.data = dataTwoT
               pieChart.legend.enabled = false
    }//end of func
    
    func setInitData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let refThree = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: 0)))
          refThree.observeSingleEvent(of: .value, with: { (snapshot) in
            print(self.retDate(n: 0))
            let value = snapshot.value as? NSDictionary
            let timerVal = value?["timer"] as? Int ?? 0
            let taskVal =  value?["tasks"] as? Int ?? 0
            
            self.pieTwo = Int(timerVal)
            self.pieOne = Int(taskVal)
            
            
            self.setPieG(x: timerVal, y: taskVal)
           
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
    }//end of if
    
    
    

    @IBAction func exitOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func xData(n: Int) {
        var x = 0
       // var xT = 0
        guard let uid = Auth.auth().currentUser?.uid else { return }
      //  let refTwo = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: n))).child("timer")
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: n)))//.child("tasks")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
          
          let value = snapshot.value as? NSDictionary
          let username = value?["tasks"] as? Int ?? 0
           x = Int(username)
            
            if n == 0{
                self.xOne = x
            }//end of if
            else if n == 1{
                self.xTwo = x
            }//end of if
            else if n == 2{
                self.xThree = x
            }//end of if
            else if n == 3{
                self.xFour = x
            }//end of if
            else if n == 4{
                self.xFive = x
            }//end of if
            else if n == 5{
                self.xSix = x
            }//end of if
            else if n == 6{
                self.xSeven = x
            }//end of if
            
          }) { (error) in
            print(error.localizedDescription)
        }//end of error
    }//end of xData
    
    func yData(n: Int){
        var x = 0
         // var xT = 0
          guard let uid = Auth.auth().currentUser?.uid else { return }
       
          let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: n)))//.child("tasks")
          ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let username = value?["timer"] as? Int ?? 0
             x = Int(username)
            
            if n == 0{
                self.yOne = x
            }//end of if
            else if n == 1{
                self.yTwo = x
            }//end of if
            else if n == 2{
                self.yThree = x
            }//end of if
            else if n == 3{
                self.yFour = x
            }//end of if
            else if n == 4{
                self.yFive = x
            }//end of if
            else if n == 5{
                self.ySix = x
            }//end of if
            else if n == 6{
                self.ySeven = x
            }//end of if
                       
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
    }//end of func
    
    func retDate(n: Int) -> Int{
        if n == 0{
            let calendar = Calendar.current
            let date = Date()
            return calendar.component(.day, from: date)
        }//end of if
        
        if n == 1{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) - 1
            
            if x <= 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30
                }//end of nested if
                else{
                    return 31
                }//end of else
            }//end of if
            else{
                return x
            }//end of else
        }//end of inital if
        
        if n == 2{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) - 2
            
            if x == 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30
                }//end of nested if
                else{
                    return 31
                }//end of else
            }//end of if
            else if x < 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30 - x
                }//end of nested if
                else{
                    return 31 - x
                }//end of else
            }//end of else if
            else{
                return x
            }//end of else
        }//end of inital if
        
        if n == 3{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) - 3
            
            if x == 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30
                }//end of nested if
                else{
                    return 31
                }//end of else
            }//end of if
            else if x < 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30 - x
                }//end of nested if
                else{
                    return 31 - x
                }//end of else
            }//end of else if
            else{
                return x
            }//end of else
        }//end of inital if
        
        if n == 4{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) - 4
            
            if x == 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30
                }//end of nested if
                else{
                    return 31
                }//end of else
            }//end of if
            else if x < 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30 - x
                }//end of nested if
                else{
                    return 31 - x
                }//end of else
            }//end of else if
            else{
                return x
            }//end of else
        }//end of inital if
        
        if n == 5{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) - 5
            
            if x == 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30
                }//end of nested if
                else{
                    return 31
                }//end of else
            }//end of if
            else if x < 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30 - x
                }//end of nested if
                else{
                    return 31 - x
                }//end of else
            }//end of else if
            else{
                return x
            }//end of else
        }//end of inital if
        
        if n == 6{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) - 6
            
            if x == 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30
                }//end of nested if
                else{
                    return 31
                }//end of else
            }//end of if
            else if x < 0{
                if calendar.component(.month, from: date)-1 != 1, calendar.component(.month, from: date)-1 != 3, calendar.component(.month, from: date)-1 != 5, calendar.component(.month, from: date)-1 != 7, calendar.component(.month, from: date)-1 != 8, calendar.component(.month, from: date)-1 != 9, calendar.component(.month, from: date)-1 != 12{
                    return 30 - x
                }//end of nested if
                else{
                    return 31 - x
                }//end of else
            }//end of else if
            else{
                return x
            }//end of else
        }//end of inital if
        return 0
    }//end of func
    
    func setColors(c: Int){
        
        if c == 0{
            monday.backgroundColor = UIColor.white
            monday.setTitleColor(UIColor.systemGreen, for: .normal)
            monday.layer.shadowColor = UIColor.lightGray.cgColor
            monday.layer.shadowOpacity = 1
            monday.layer.shadowOffset = .init(width: 0, height: 1)
            monday.layer.shadowRadius = 1
            
            tuesday.backgroundColor = UIColor.systemGreen
            tuesday.setTitleColor(UIColor.white, for: .normal)
            tuesday.layer.shadowColor = UIColor.clear.cgColor
            tuesday.layer.shadowOpacity = 1
            tuesday.layer.shadowOffset = .init(width: 0, height: 1)
            tuesday.layer.shadowRadius = 1
            
            wednesday.backgroundColor = UIColor.systemGreen
            wednesday.setTitleColor(UIColor.white, for: .normal)
            wednesday.layer.shadowColor = UIColor.clear.cgColor
            wednesday.layer.shadowOpacity = 1
            wednesday.layer.shadowOffset = .init(width: 0, height: 1)
            wednesday.layer.shadowRadius = 1
            
            thursday.backgroundColor = UIColor.systemGreen
            thursday.setTitleColor(UIColor.white, for: .normal)
            thursday.layer.shadowColor = UIColor.clear.cgColor
            thursday.layer.shadowOpacity = 1
            thursday.layer.shadowOffset = .init(width: 0, height: 1)
            thursday.layer.shadowRadius = 1
            
            friday.backgroundColor = UIColor.systemGreen
            friday.setTitleColor(UIColor.white, for: .normal)
            friday.layer.shadowColor = UIColor.clear.cgColor
            friday.layer.shadowOpacity = 1
            friday.layer.shadowOffset = .init(width: 0, height: 1)
            friday.layer.shadowRadius = 1
            
            saturday.backgroundColor = UIColor.systemGreen
            saturday.setTitleColor(UIColor.white, for: .normal)
            saturday.layer.shadowColor = UIColor.clear.cgColor
            saturday.layer.shadowOpacity = 1
            saturday.layer.shadowOffset = .init(width: 0, height: 1)
            saturday.layer.shadowRadius = 1
            
            sunday.backgroundColor = UIColor.systemGreen
            sunday.setTitleColor(UIColor.white, for: .normal)
            sunday.layer.shadowColor = UIColor.clear.cgColor
            sunday.layer.shadowOpacity = 1
            sunday.layer.shadowOffset = .init(width: 0, height: 1)
            sunday.layer.shadowRadius = 1
        }//end of if
        else if c == 1{
            tuesday.backgroundColor = UIColor.white
            tuesday.setTitleColor(UIColor.systemGreen, for: .normal)
            tuesday.layer.shadowColor = UIColor.lightGray.cgColor
            tuesday.layer.shadowOpacity = 1
            tuesday.layer.shadowOffset = .init(width: 0, height: 1)
            tuesday.layer.shadowRadius = 1
            
            monday.backgroundColor = UIColor.systemGreen
            monday.setTitleColor(UIColor.white, for: .normal)
            monday.layer.shadowColor = UIColor.clear.cgColor
            monday.layer.shadowOpacity = 1
            monday.layer.shadowOffset = .init(width: 0, height: 1)
            monday.layer.shadowRadius = 1
            
            wednesday.backgroundColor = UIColor.systemGreen
            wednesday.setTitleColor(UIColor.white, for: .normal)
            wednesday.layer.shadowColor = UIColor.clear.cgColor
            wednesday.layer.shadowOpacity = 1
            wednesday.layer.shadowOffset = .init(width: 0, height: 1)
            wednesday.layer.shadowRadius = 1
            
            thursday.backgroundColor = UIColor.systemGreen
            thursday.setTitleColor(UIColor.white, for: .normal)
            thursday.layer.shadowColor = UIColor.clear.cgColor
            thursday.layer.shadowOpacity = 1
            thursday.layer.shadowOffset = .init(width: 0, height: 1)
            thursday.layer.shadowRadius = 1
            
            friday.backgroundColor = UIColor.systemGreen
            friday.setTitleColor(UIColor.white, for: .normal)
            friday.layer.shadowColor = UIColor.clear.cgColor
            friday.layer.shadowOpacity = 1
            friday.layer.shadowOffset = .init(width: 0, height: 1)
            friday.layer.shadowRadius = 1
            
            saturday.backgroundColor = UIColor.systemGreen
            saturday.setTitleColor(UIColor.white, for: .normal)
            saturday.layer.shadowColor = UIColor.clear.cgColor
            saturday.layer.shadowOpacity = 1
            saturday.layer.shadowOffset = .init(width: 0, height: 1)
            saturday.layer.shadowRadius = 1
            
            sunday.backgroundColor = UIColor.systemGreen
            sunday.setTitleColor(UIColor.white, for: .normal)
            sunday.layer.shadowColor = UIColor.clear.cgColor
            sunday.layer.shadowOpacity = 1
            sunday.layer.shadowOffset = .init(width: 0, height: 1)
            sunday.layer.shadowRadius = 1
        }
        else if c == 2{
            wednesday.backgroundColor = UIColor.white
            wednesday.setTitleColor(UIColor.systemGreen, for: .normal)
            wednesday.layer.shadowColor = UIColor.lightGray.cgColor
            wednesday.layer.shadowOpacity = 1
            wednesday.layer.shadowOffset = .init(width: 0, height: 1)
            wednesday.layer.shadowRadius = 1
            
            tuesday.backgroundColor = UIColor.systemGreen
            tuesday.setTitleColor(UIColor.white, for: .normal)
            tuesday.layer.shadowColor = UIColor.clear.cgColor
            tuesday.layer.shadowOpacity = 1
            tuesday.layer.shadowOffset = .init(width: 0, height: 1)
            tuesday.layer.shadowRadius = 1
            
            monday.backgroundColor = UIColor.systemGreen
            monday.setTitleColor(UIColor.white, for: .normal)
            monday.layer.shadowColor = UIColor.clear.cgColor
            monday.layer.shadowOpacity = 1
            monday.layer.shadowOffset = .init(width: 0, height: 1)
            monday.layer.shadowRadius = 1
            
            thursday.backgroundColor = UIColor.systemGreen
            thursday.setTitleColor(UIColor.white, for: .normal)
            thursday.layer.shadowColor = UIColor.clear.cgColor
            thursday.layer.shadowOpacity = 1
            thursday.layer.shadowOffset = .init(width: 0, height: 1)
            thursday.layer.shadowRadius = 1
            
            friday.backgroundColor = UIColor.systemGreen
            friday.setTitleColor(UIColor.white, for: .normal)
            friday.layer.shadowColor = UIColor.clear.cgColor
            friday.layer.shadowOpacity = 1
            friday.layer.shadowOffset = .init(width: 0, height: 1)
            friday.layer.shadowRadius = 1
            
            saturday.backgroundColor = UIColor.systemGreen
            saturday.setTitleColor(UIColor.white, for: .normal)
            saturday.layer.shadowColor = UIColor.clear.cgColor
            saturday.layer.shadowOpacity = 1
            saturday.layer.shadowOffset = .init(width: 0, height: 1)
            saturday.layer.shadowRadius = 1
            
            sunday.backgroundColor = UIColor.systemGreen
            sunday.setTitleColor(UIColor.white, for: .normal)
            sunday.layer.shadowColor = UIColor.clear.cgColor
            sunday.layer.shadowOpacity = 1
            sunday.layer.shadowOffset = .init(width: 0, height: 1)
            sunday.layer.shadowRadius = 1
        }
        else if c == 3{
            thursday.backgroundColor = UIColor.white
            thursday.setTitleColor(UIColor.systemGreen, for: .normal)
            thursday.layer.shadowColor = UIColor.lightGray.cgColor
            thursday.layer.shadowOpacity = 1
            thursday.layer.shadowOffset = .init(width: 0, height: 1)
            thursday.layer.shadowRadius = 1
            
            tuesday.backgroundColor = UIColor.systemGreen
            tuesday.setTitleColor(UIColor.white, for: .normal)
            tuesday.layer.shadowColor = UIColor.clear.cgColor
            tuesday.layer.shadowOpacity = 1
            tuesday.layer.shadowOffset = .init(width: 0, height: 1)
            tuesday.layer.shadowRadius = 1
            
            wednesday.backgroundColor = UIColor.systemGreen
            wednesday.setTitleColor(UIColor.white, for: .normal)
            wednesday.layer.shadowColor = UIColor.clear.cgColor
            wednesday.layer.shadowOpacity = 1
            wednesday.layer.shadowOffset = .init(width: 0, height: 1)
            wednesday.layer.shadowRadius = 1
            
            monday.backgroundColor = UIColor.systemGreen
            monday.setTitleColor(UIColor.white, for: .normal)
            monday.layer.shadowColor = UIColor.clear.cgColor
            monday.layer.shadowOpacity = 1
            monday.layer.shadowOffset = .init(width: 0, height: 1)
            monday.layer.shadowRadius = 1
            
            friday.backgroundColor = UIColor.systemGreen
            friday.setTitleColor(UIColor.white, for: .normal)
            friday.layer.shadowColor = UIColor.clear.cgColor
            friday.layer.shadowOpacity = 1
            friday.layer.shadowOffset = .init(width: 0, height: 1)
            friday.layer.shadowRadius = 1
            
            saturday.backgroundColor = UIColor.systemGreen
            saturday.setTitleColor(UIColor.white, for: .normal)
            saturday.layer.shadowColor = UIColor.clear.cgColor
            saturday.layer.shadowOpacity = 1
            saturday.layer.shadowOffset = .init(width: 0, height: 1)
            saturday.layer.shadowRadius = 1
            
            sunday.backgroundColor = UIColor.systemGreen
            sunday.setTitleColor(UIColor.white, for: .normal)
            sunday.layer.shadowColor = UIColor.clear.cgColor
            sunday.layer.shadowOpacity = 1
            sunday.layer.shadowOffset = .init(width: 0, height: 1)
            sunday.layer.shadowRadius = 1
        }
        else if c == 4{
            friday.backgroundColor = UIColor.white
            friday.setTitleColor(UIColor.systemGreen, for: .normal)
            friday.layer.shadowColor = UIColor.lightGray.cgColor
            friday.layer.shadowOpacity = 1
            friday.layer.shadowOffset = .init(width: 0, height: 1)
            friday.layer.shadowRadius = 1
            
            tuesday.backgroundColor = UIColor.systemGreen
            tuesday.setTitleColor(UIColor.white, for: .normal)
            tuesday.layer.shadowColor = UIColor.clear.cgColor
            tuesday.layer.shadowOpacity = 1
            tuesday.layer.shadowOffset = .init(width: 0, height: 1)
            tuesday.layer.shadowRadius = 1
            
            wednesday.backgroundColor = UIColor.systemGreen
            wednesday.setTitleColor(UIColor.white, for: .normal)
            wednesday.layer.shadowColor = UIColor.clear.cgColor
            wednesday.layer.shadowOpacity = 1
            wednesday.layer.shadowOffset = .init(width: 0, height: 1)
            wednesday.layer.shadowRadius = 1
            
            thursday.backgroundColor = UIColor.systemGreen
            thursday.setTitleColor(UIColor.white, for: .normal)
            thursday.layer.shadowColor = UIColor.clear.cgColor
            thursday.layer.shadowOpacity = 1
            thursday.layer.shadowOffset = .init(width: 0, height: 1)
            thursday.layer.shadowRadius = 1
            
            monday.backgroundColor = UIColor.systemGreen
            monday.setTitleColor(UIColor.white, for: .normal)
            monday.layer.shadowColor = UIColor.clear.cgColor
            monday.layer.shadowOpacity = 1
            monday.layer.shadowOffset = .init(width: 0, height: 1)
            monday.layer.shadowRadius = 1
            
            saturday.backgroundColor = UIColor.systemGreen
            saturday.setTitleColor(UIColor.white, for: .normal)
            saturday.layer.shadowColor = UIColor.clear.cgColor
            saturday.layer.shadowOpacity = 1
            saturday.layer.shadowOffset = .init(width: 0, height: 1)
            saturday.layer.shadowRadius = 1
            
            sunday.backgroundColor = UIColor.systemGreen
            sunday.setTitleColor(UIColor.white, for: .normal)
            sunday.layer.shadowColor = UIColor.clear.cgColor
            sunday.layer.shadowOpacity = 1
            sunday.layer.shadowOffset = .init(width: 0, height: 1)
            sunday.layer.shadowRadius = 1
        }
        else if c == 5{
            saturday.backgroundColor = UIColor.white
            saturday.setTitleColor(UIColor.systemGreen, for: .normal)
            saturday.layer.shadowColor = UIColor.lightGray.cgColor
            saturday.layer.shadowOpacity = 1
            saturday.layer.shadowOffset = .init(width: 0, height: 1)
            saturday.layer.shadowRadius = 1
            
            tuesday.backgroundColor = UIColor.systemGreen
            tuesday.setTitleColor(UIColor.white, for: .normal)
            tuesday.layer.shadowColor = UIColor.clear.cgColor
            tuesday.layer.shadowOpacity = 1
            tuesday.layer.shadowOffset = .init(width: 0, height: 1)
            tuesday.layer.shadowRadius = 1
            
            wednesday.backgroundColor = UIColor.systemGreen
            wednesday.setTitleColor(UIColor.white, for: .normal)
            wednesday.layer.shadowColor = UIColor.clear.cgColor
            wednesday.layer.shadowOpacity = 1
            wednesday.layer.shadowOffset = .init(width: 0, height: 1)
            wednesday.layer.shadowRadius = 1
            
            thursday.backgroundColor = UIColor.systemGreen
            thursday.setTitleColor(UIColor.white, for: .normal)
            thursday.layer.shadowColor = UIColor.clear.cgColor
            thursday.layer.shadowOpacity = 1
            thursday.layer.shadowOffset = .init(width: 0, height: 1)
            thursday.layer.shadowRadius = 1
            
            friday.backgroundColor = UIColor.systemGreen
            friday.setTitleColor(UIColor.white, for: .normal)
            friday.layer.shadowColor = UIColor.clear.cgColor
            friday.layer.shadowOpacity = 1
            friday.layer.shadowOffset = .init(width: 0, height: 1)
            friday.layer.shadowRadius = 1
            
            monday.backgroundColor = UIColor.systemGreen
            monday.setTitleColor(UIColor.white, for: .normal)
            monday.layer.shadowColor = UIColor.clear.cgColor
            monday.layer.shadowOpacity = 1
            monday.layer.shadowOffset = .init(width: 0, height: 1)
            monday.layer.shadowRadius = 1
            
            sunday.backgroundColor = UIColor.systemGreen
            sunday.setTitleColor(UIColor.white, for: .normal)
            sunday.layer.shadowColor = UIColor.clear.cgColor
            sunday.layer.shadowOpacity = 1
            sunday.layer.shadowOffset = .init(width: 0, height: 1)
            sunday.layer.shadowRadius = 1
        }
        else if c == 6{
            sunday.backgroundColor = UIColor.white
            sunday.setTitleColor(UIColor.systemGreen, for: .normal)
            sunday.layer.shadowColor = UIColor.lightGray.cgColor
            sunday.layer.shadowOpacity = 1
            sunday.layer.shadowOffset = .init(width: 0, height: 1)
            sunday.layer.shadowRadius = 1
            
            tuesday.backgroundColor = UIColor.systemGreen
            tuesday.setTitleColor(UIColor.white, for: .normal)
            tuesday.layer.shadowColor = UIColor.clear.cgColor
            tuesday.layer.shadowOpacity = 1
            tuesday.layer.shadowOffset = .init(width: 0, height: 1)
            tuesday.layer.shadowRadius = 1
            
            wednesday.backgroundColor = UIColor.systemGreen
            wednesday.setTitleColor(UIColor.white, for: .normal)
            wednesday.layer.shadowColor = UIColor.clear.cgColor
            wednesday.layer.shadowOpacity = 1
            wednesday.layer.shadowOffset = .init(width: 0, height: 1)
            wednesday.layer.shadowRadius = 1
            
            thursday.backgroundColor = UIColor.systemGreen
            thursday.setTitleColor(UIColor.white, for: .normal)
            thursday.layer.shadowColor = UIColor.clear.cgColor
            thursday.layer.shadowOpacity = 1
            thursday.layer.shadowOffset = .init(width: 0, height: 1)
            thursday.layer.shadowRadius = 1
            
            friday.backgroundColor = UIColor.systemGreen
            friday.setTitleColor(UIColor.white, for: .normal)
            friday.layer.shadowColor = UIColor.clear.cgColor
            friday.layer.shadowOpacity = 1
            friday.layer.shadowOffset = .init(width: 0, height: 1)
            friday.layer.shadowRadius = 1
            
            saturday.backgroundColor = UIColor.systemGreen
            saturday.setTitleColor(UIColor.white, for: .normal)
            saturday.layer.shadowColor = UIColor.clear.cgColor
            saturday.layer.shadowOpacity = 1
            saturday.layer.shadowOffset = .init(width: 0, height: 1)
            saturday.layer.shadowRadius = 1
            
            monday.backgroundColor = UIColor.systemGreen
            monday.setTitleColor(UIColor.white, for: .normal)
            monday.layer.shadowColor = UIColor.clear.cgColor
            monday.layer.shadowOpacity = 1
            monday.layer.shadowOffset = .init(width: 0, height: 1)
            monday.layer.shadowRadius = 1
        }//end of else if
    }//end of func
    
    @IBAction func firstCell(_ sender: Any) {
        setColors(c:0)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: 6)))
          ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let timerVal = value?["timer"] as? Int ?? 0
            let taskVal =  value?["tasks"] as? Int ?? 0
            
            self.pieTwo = timerVal
            self.pieOne = taskVal
            
            self.setPieG(x: timerVal, y: taskVal)
            
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
    }//end of func
    
    @IBAction func secondCell(_ sender: Any) {
        setColors(c: 1)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: 5)))
          ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let timerVal = value?["timer"] as? Int ?? 0
            let taskVal =  value?["tasks"] as? Int ?? 0
            
            self.pieTwo = timerVal
            self.pieOne = taskVal
            
            self.setPieG(x: timerVal, y: taskVal)
            
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
        
    }
    
    @IBAction func thirdCell(_ sender: Any) {
        setColors(c: 2)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: 4)))
          ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let timerVal = value?["timer"] as? Int ?? 0
            let taskVal =  value?["tasks"] as? Int ?? 0
            
            self.pieTwo = timerVal
            self.pieOne = taskVal
            
            self.setPieG(x: timerVal, y: taskVal)
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
        
    }//end of func
    
    @IBAction func fourthCell(_ sender: Any) {
        setColors(c: 3)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: 3)))
          ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let timerVal = value?["timer"] as? Int ?? 0
            let taskVal =  value?["tasks"] as? Int ?? 0
            
            self.pieTwo = timerVal
            self.pieOne = taskVal
            
            self.setPieG(x: timerVal, y: taskVal)
            
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
    }
    
    @IBAction func fifthCell(_ sender: Any) {
        setColors(c: 4)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: 2)))
          ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let timerVal = value?["timer"] as? Int ?? 0
            let taskVal =  value?["tasks"] as? Int ?? 0
            
            self.pieTwo = timerVal
            self.pieOne = taskVal
            
            self.setPieG(x: timerVal, y: taskVal)
            
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
    }
    
    @IBAction func sixthCell(_ sender: Any) {
        setColors(c: 5)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: 1)))
          ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let timerVal = value?["timer"] as? Int ?? 0
            let taskVal =  value?["tasks"] as? Int ?? 0
            
            self.pieTwo = timerVal
            self.pieOne = taskVal
            
            self.setPieG(x: timerVal, y: taskVal)
            
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
        //view.addSubview(pieChart)
    }
    
    @IBAction func seventhCell(_ sender: Any) {
        setColors(c: 6)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(retDate(n: 0)))
          ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let timerVal = value?["timer"] as? Int ?? 0
            let taskVal =  value?["tasks"] as? Int ?? 0
            
            self.pieTwo = timerVal
            self.pieOne = taskVal
            
            self.setPieG(x: timerVal, y: taskVal)
                       
        }) { (error) in
            print(error.localizedDescription)
        }//end of error
    }
    
    func setPieG(x: Int, y: Int){
                
       if x > 0 || y > 0 {
          self.setTwo.removeAll()
          self.setTwo = PieChartDataSet(entries: [
               PieChartDataEntry(value: Double(x), data: x),
               PieChartDataEntry(value: Double(y), data: y),
           ])
          self.view.willRemoveSubview(self.pieChart)
          self.view.addSubview(self.pieChart)

        }//end of if
        else{
            pieChart.clear()
            pieChart.noDataText = "No Data Available"
        }//end of if
    }//end of func
    
}//end of class
