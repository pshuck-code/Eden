//
//  AddTodoViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 7/2/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class AddTodoViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var todoTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var prioButton: UIBarButtonItem!
    
    var sayNum: TodoListViewController!
    var curNum = 0
    var curGate = 0
    var priority = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sayNum = TodoListViewController()
        curNum = sayNum!.dayNum
        curGate = sayNum!.getDate(curNum)
        addButton.layer.cornerRadius = 15
        todoTextView.text = "Say something positive!"
        todoTextView.textColor = UIColor.lightGray
        todoTextView.font = UIFont(name: "verdana", size: 15)
        todoTextView.returnKeyType = .done
        todoTextView.delegate = self
    }//end of viewDidLoad
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let firstVC = presentingViewController as? TodoListViewController {
            DispatchQueue.main.async {
                firstVC.loadTodos(n: firstVC.dayNum)
            }//end of async
        }//end of if
    }//end of func
    
    @IBAction func addAction(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let todoText = todoTextView.text
        //self.todos.append(Todo(isChecked: false, todoName: todoText!))
        
        let ref = Database.database().reference(withPath: "users").child("profile").child(uid).child("todos").child(String(sayNum!.getDate(self.curNum)))

        let userObject = [
            "isChecked": false,
            "priority": priority
        ] as [String:Any]
        
        ref.child(todoText!).setValue(userObject)
        
        dismiss(animated: true, completion: nil)
        
        /*
         
         let userObject = [
             "username": username,
             "photoURL": profileImageURL.absoluteString
         ] as [String:Any]
         databaseRef.setValue(userObject) { error, ref in
             completion(error == nil)
         }//end of databaseRef
         
         */
        
        
    }//end of func
    
    @IBAction func exitAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }//end of func
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Say something positive!"{
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "verdana", size: 20)
        }//end of if
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }//end of if
        return true
    }//end of func

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            todoTextView.text = "Say something positive!"
            todoTextView.textColor = UIColor.lightGray
            todoTextView.font = UIFont(name: "verdana", size: 15)
        }//end of if
     }//end of func
    
    @IBAction func setPriority(_ sender: Any) {
        let alert = UIAlertController(title: "Please select a priority for this task", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Priority A", style: .default, handler: { action in
            self.priority = 1
            self.prioButton.tintColor = UIColor.systemRed
        }))
        alert.addAction(UIAlertAction(title: "Priority B", style: .default, handler: { action in
            self.priority = 2
            self.prioButton.tintColor = UIColor.systemOrange
        }))
         alert.addAction(UIAlertAction(title: "Priority C", style: .default, handler: { action in
            self.priority = 3
            self.prioButton.tintColor = UIColor.systemBlue
        }))
         alert.addAction(UIAlertAction(title: "Priority D", style: .default, handler: { action in
            self.priority = 4
            self.prioButton.tintColor = UIColor.systemPurple
        }))

        self.present(alert, animated: true)
    }//end of func
        
}//end of class

