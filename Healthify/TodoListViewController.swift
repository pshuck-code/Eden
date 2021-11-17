//
//  TodoListViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 6/21/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import Firebase
import ViewAnimator

struct Todo {
    var isChecked: Bool
    var todoName: String
    var priorNum: Int
}

public protocol LosslessStringConvertible: CustomStringConvertible {
  init? (_ description: String)
}

public protocol CustomStringConvertible {
  var description: String { get }
}

class TodoListViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var todos: [Todo] = []
    @IBOutlet weak var todoTV: UITableView!
    @IBOutlet weak var addTodoButton: UIButton!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var checkMarkCircle: UIImageView!
    
    var taskNum = 0
    var priorHolder = 0
    var dayNum = UserDefaults.standard.integer(forKey: "number")
    var currDay = UserDefaults.standard.integer(forKey: "day")
    var taskHolder = UserDefaults.standard.integer(forKey: "task")
    let userDefaults = UserDefaults.standard
    
    let homeSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 55, weight: .black)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.set(0, forKey: "number")
        userDefaults.set(getDate(0), forKey: "day")
        userDefaults.set(0, forKey: "task")
        
        dayNum = userDefaults.integer(forKey: "number")
        currDay = userDefaults.integer(forKey: "day")
        taskHolder = userDefaults.integer(forKey: "task")
        
        todoTV.delegate = self
        todoTV.dataSource = self
        todoTV.rowHeight = 80
        todoTV.tableFooterView = UIView()
        
        checkMarkCircle.isHidden = true
        
        addTodoButton.layer.cornerRadius = addTodoButton.bounds.height/2
        addTodoButton.layer.shadowColor = UIColor.lightGray.cgColor
        addTodoButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        addTodoButton.layer.shadowOpacity = 1.0
        
        monday.layer.cornerRadius = 10
        tuesday.layer.cornerRadius = 10
        wednesday.layer.cornerRadius = 10
        thursday.layer.cornerRadius = 10
        friday.layer.cornerRadius = 10
        saturday.layer.cornerRadius = 10
        sunday.layer.cornerRadius = 10

        
        let calendar = Calendar.current
        let date = Date()
        let one = calendar.date(byAdding: .day, value: 1, to: date)
        
        monday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        tuesday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        wednesday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        thursday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        friday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        saturday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        sunday.titleLabel?.font =  UIFont(name: "Verdana", size: 18)
        
        monday.backgroundColor = UIColor.white
        monday.setTitleColor(UIColor.systemGreen, for: .normal)
        monday.layer.shadowColor = UIColor.lightGray.cgColor
        monday.layer.shadowOpacity = 1
        monday.layer.shadowOffset = .init(width: 0, height: 1)
        monday.layer.shadowRadius = 1
        
        monday.setTitle(String(getDate(0)), for: .normal)
        tuesday.setTitle(String(getDate(1)), for: .normal)
        wednesday.setTitle(String(getDate(2)), for: .normal)
        thursday.setTitle(String(getDate(3)), for: .normal)
        friday.setTitle(String(getDate(4)), for: .normal)
        saturday.setTitle(String(getDate(5)), for: .normal)
        sunday.setTitle(String(getDate(6)), for: .normal)
        
        //loadTodos(n: dayNum)
        decideInitDay(dayNum)
        //todoTV.reloadData()
    }//end of viewDidLoad
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }//end of goBack function
    
    @IBAction func firstCell(_ sender: Any) {
        loadTodos(n: 0)
        let userDefaults = UserDefaults.standard
        userDefaults.set(0, forKey: "number")
        dayNum = userDefaults.integer(forKey: "number")
        setColors(c: 0)
    }
    
    @IBAction func secCell(_ sender: Any) {
        loadTodos(n: 1)
        userDefaults.set(1, forKey: "number")
        dayNum = userDefaults.integer(forKey: "number")
        setColors(c: 1)
    }
    
    @IBAction func thirdCell(_ sender: Any) {
        loadTodos(n: 2)
        userDefaults.set(2, forKey: "number")
        dayNum = userDefaults.integer(forKey: "number")
        setColors(c: 2)
    }
    
    @IBAction func fourCell(_ sender: Any) {
        loadTodos(n: 3)
        userDefaults.set(3, forKey: "number")
        dayNum = userDefaults.integer(forKey: "number")
        setColors(c: 3)
    }
    
    @IBAction func fifthCell(_ sender: Any) {
        loadTodos(n: 4)
        userDefaults.set(4, forKey: "number")
        dayNum = userDefaults.integer(forKey: "number")
        setColors(c: 4)
    }
    
    @IBAction func sixthCell(_ sender: Any) {
        loadTodos(n: 5)
        userDefaults.set(5, forKey: "number")
        dayNum = userDefaults.integer(forKey: "number")
        setColors(c: 5)
    }
    
    @IBAction func sevenCell(_ sender: Any) {
        loadTodos(n: 6)
        userDefaults.set(6, forKey: "number")
        dayNum = userDefaults.integer(forKey: "number")
        setColors(c: 6)
    }
    
    func decideInitDay(_ n: Int){
        if n == 0{
            loadTodos(n: n)
        }
        else if n == 1{
            loadTodos(n: n)
        }
        else if n == 2{
            loadTodos(n: n)
        }
        else if n == 3{
            loadTodos(n: n)
        }
        else if n == 4{
            loadTodos(n: n)
        }
        else if n == 5{
            loadTodos(n: n)
        }
        else if n == 6{
           loadTodos(n: n)
        }
    }//end of func
    
    func loadTodos(n: Int){
        self.todos.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("todos").child(String(getDate(n)))
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let todoName = child.key
                let todoRef = ref.child(todoName)
                
                todoRef.observeSingleEvent(of: .value) { (todoSnapshot) in
                    let value = todoSnapshot.value as? NSDictionary
                    let isChecked = value!["isChecked"] as? Bool
                    let priorNum = value!["priority"] as? Int
                    self.priorHolder = priorNum!
                    print(self.priorHolder, "eyeye")
                        self.todos.append(Todo(isChecked: isChecked!, todoName: todoName, priorNum: priorNum!))
                    self.todoTV.reloadData()
                }
            }//end of for
            self.todoTV.reloadData()
        }//end of .observeSingleEvent
    }//end of func

    func getDate(_ n: Int) -> Int{
        if n == 0{
            let calendar = Calendar.current
            let date = Date()
            return calendar.component(.day, from: date)
        }//end of if
        
        if n == 1{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) + 1
            
            if x > 30{
                if calendar.component(.month, from: date) != 1, calendar.component(.month, from: date) != 3, calendar.component(.month, from: date) != 5, calendar.component(.month, from: date) != 7, calendar.component(.month, from: date) != 8, calendar.component(.month, from: date) != 9, calendar.component(.month, from: date) != 12{
                    return x - 30
                }//end of nested if
                else if x != 31{
                     return x - 31
                }//end of else
                else{
                    return 31
                }//end of else
            }//end of if
            else{
                return x
            }//end of else
        }//end of inital if
        else if n == 2{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) + 2
            
            if x > 30{
                if calendar.component(.month, from: date) != 1, calendar.component(.month, from: date) != 3, calendar.component(.month, from: date) != 5, calendar.component(.month, from: date) != 7, calendar.component(.month, from: date) != 8, calendar.component(.month, from: date) != 9, calendar.component(.month, from: date) != 12{
                    return x - 30
                }//end of nested if
                else if x != 31{
                     return x - 31
                }//end of else
                else{
                    return 31
                }//end of else
            }//end of if
            else{
                return x
            }//end of else
        }
        else if n == 3{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) + 3
            
            if x > 30{
                if calendar.component(.month, from: date) != 1, calendar.component(.month, from: date) != 3, calendar.component(.month, from: date) != 5, calendar.component(.month, from: date) != 7, calendar.component(.month, from: date) != 8, calendar.component(.month, from: date) != 9, calendar.component(.month, from: date) != 12{
                    return x - 30
                }//end of nested if
                else if x != 31{
                     return x - 31
                }//end of else
                else{
                    return 31
                }//end of else
            }//end of if
            else{
                return x
            }//end of else
        }
        else if n == 4{
           let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) + 4
            
            if x > 30{
                if calendar.component(.month, from: date) != 1, calendar.component(.month, from: date) != 3, calendar.component(.month, from: date) != 5, calendar.component(.month, from: date) != 7, calendar.component(.month, from: date) != 8, calendar.component(.month, from: date) != 9, calendar.component(.month, from: date) != 12{
                    return x - 30
                }//end of nested if
                else if x != 31{
                     return x - 31
                }//end of else
                else{
                    return 31
                }//end of else
            }//end of if
            else{
                return x
            }//end of else
        }
        else if n == 5{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) + 5
            
            if x > 30{
                if calendar.component(.month, from: date) != 1, calendar.component(.month, from: date) != 3, calendar.component(.month, from: date) != 5, calendar.component(.month, from: date) != 7, calendar.component(.month, from: date) != 8, calendar.component(.month, from: date) != 9, calendar.component(.month, from: date) != 12{
                    return x - 30
                }//end of nested if
                else if x != 31{
                     return x - 31
                }//end of else
                else{
                    return 31
                }//end of else
            }//end of if
            else{
                return x
            }//end of else
        }
        else if n == 6{
            let calendar = Calendar.current
            let date = Date()
            let x = calendar.component(.day, from: date) + 6
            
            if x > 30{
                if calendar.component(.month, from: date) != 1, calendar.component(.month, from: date) != 3, calendar.component(.month, from: date) != 5, calendar.component(.month, from: date) != 7, calendar.component(.month, from: date) != 8, calendar.component(.month, from: date) != 9, calendar.component(.month, from: date) != 12{
                    return x - 30
                }//end of nested if
                else if x != 31{
                     return x - 31
                }//end of else
                else{
                    return 31
                }//end of else
            }//end of if
            else{
                return x
            }//end of else
        }
            return 0
    }//end of getDate
    
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
        }
        
    }//end of func
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }//end of numberOfSections
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }//end of tableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        cell.todoLabel.text = todos[indexPath.row].todoName
        priorHolder = todos[indexPath.row].priorNum
        
        if priorHolder == 0{
            cell.priorityFlag.tintColor = UIColor.lightGray
        }
        if priorHolder == 1 {
            cell.priorityFlag.tintColor = UIColor.red
        }//end of if
        else if priorHolder == 2 {
            cell.priorityFlag.tintColor = UIColor.orange
        }//end of if
        else if priorHolder == 3 {
            cell.priorityFlag.tintColor = UIColor.blue
        }//end of if
        else if priorHolder == 4 {
            cell.priorityFlag.tintColor = UIColor.purple
        }//end of if
        
        print(priorHolder)
        
        if todos[indexPath.row].isChecked {
            cell.checkMarkImage.image = UIImage(named: "Icon-40")
            checkMarkCircle.center = view.center
            view.addSubview(checkMarkCircle)
            
            checkMarkCircle.isHidden = false
            checkMarkCircle.animate(animations: [AnimationType.rotate(angle: .pi/1)])
        }//end of if
        else{
            cell.checkMarkImage.image = UIImage(named: "Icon-20")

        }//end of else
        
        return cell
    }//end of cellForRowAt
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // guard let userProfile = UserService.currentUserProfile else { return print() }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("todos").child(todos[indexPath.row].todoName)
        
        if editingStyle == .delete{
            ref.removeValue()
            todos.remove(at: indexPath.row)
            todoTV.reloadData()
        }//end of if
    }//end of function

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // guard let userProfile = UserService.currentUserProfile else { return print() }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //myView.contentMode = U
        let homeImage = UIImage(systemName: "checkmark.circle", withConfiguration: homeSymbolConfiguration)
        
        let image : UIImage = homeImage!

        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("todos").child(String(self.getDate(self.dayNum))).child(todos[indexPath.row].todoName)
        
        if todos[indexPath.row].isChecked {
            todos[indexPath.row].isChecked = false
            ref.updateChildValues(["isChecked": false])
        }//end of if
        else{
            todos[indexPath.row].isChecked = true
            ref.updateChildValues(["isChecked": true])
            ref.removeValue()
            
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
    
            self.todos.remove(at: indexPath.row)
            self.todoTV.reloadData()

            self.checkMarkCircle.isHidden = true
                
            guard let uid = Auth.auth().currentUser?.uid else { return }
                    let refTwo = Database.database().reference(withPath: "users").child("profile").child(uid).child("analytics").child(String(self.getDate(0)))
                    refTwo.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let username = value?["tasks"] as? Int ?? 0
                        self.taskNum = Int(username)
                        print("username is", username)
                         print("timerNum is", self.taskNum)
                        self.taskNum = self.taskNum + 1
                        print(self.taskNum)
                        refTwo.child("tasks").setValue(self.taskNum)
                        
                }) { (error) in
                    print(error.localizedDescription)
                }//end of error
                
            timer.invalidate()
        }//end of timer
            
            
        }//end of else
        todoTV.reloadData()
        
    }//end of function
    
    func setPhoto(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,n: Int){
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        
        if n == 1{
            cell.checkMarkImage.image = UIImage(named: "checkmark.circle")
        }//end of if
        else if n == 2{
            cell.checkMarkImage.image = UIImage(named: "circle")
        }//end of if
    }//end of setPhoto
    
    @IBAction func addTodo(_ sender: Any) {
      /*  // guard let userProfile = UserService.currentUserProfile else { return print() }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let todoAlert = UIAlertController(title: "New Todo", message: "Add a todo", preferredStyle: .alert)
        todoAlert.addTextField()
        
        let addTodoAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let todoText = todoAlert.textFields![0].text
            self.todos.append(Todo(isChecked: false, todoName: todoText!))
            
            let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("todos").child(String(self.getDate(self.dayNum)))
            
            ref.child(todoText!).setValue(["isChecked": false])
            self.todoTV.reloadData()
        }//end of addTodoAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        todoAlert.addAction(addTodoAction)
        todoAlert.addAction(cancelAction)
        
        present(todoAlert, animated: true, completion: nil)*/
        self.todoTV.reloadData()
    }//end of func
    
}//end of class
extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}

