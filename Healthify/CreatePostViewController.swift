//
//  CreatePostViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 6/4/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

protocol  NewPostVCDelegate {
    func didUploadPost(withID id:String)
}

class CreatePostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var messageTextBox: UITextView!
    @IBOutlet weak var exitButton: UIButton!
    
    var delegate:NewPostVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.layer.cornerRadius = 15
        messageTextBox.text = "Say something positive!"
        messageTextBox.textColor = UIColor.lightGray
        messageTextBox.font = UIFont(name: "verdana", size: 15)
        messageTextBox.returnKeyType = .done
        messageTextBox.delegate = self
        
     //   FirebaseApp.configure()
    }//end of func
    
    @IBAction func sendPost(_ sender: Any) {
        
        guard let userProfile = UserService.currentUserProfile else { return print() } //our issue is here
       
        let postRef = Database.database().reference().child("posts").childByAutoId()
        
        let postObject = [
            "author": [
                "uid": userProfile.uid,
                "username": userProfile.username,
                "photoURL": userProfile.photoURL.absoluteString
            ],
            "text": messageTextBox.text!,
            "timestamp": [".sv":"timestamp"]
        ] as [String:Any]
        
        postRef.setValue(postObject, withCompletionBlock: {error, ref in
            if error == nil{
                self.delegate?.didUploadPost(withID: ref.key!)//come back and check on this "!"
                self.dismiss(animated: true, completion: nil)
            }//end of if
            else {
                //handle error
                print("The error is here")
            }//end of else
        })
        
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
            messageTextBox.text = "Say something positive!"
            messageTextBox.textColor = UIColor.lightGray
            messageTextBox.font = UIFont(name: "verdana", size: 15)
        }//end of if
     }//end of func
    
    @IBAction func exitOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}//end of class

