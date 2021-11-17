//
//  SecondViewController.swift
//  Healthify
//
//  Created by Parker Shuck on 4/20/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class SecondViewController: UIViewController {

    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var SignUpFinal: UIButton!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpFinal.layer.cornerRadius = 4
        
        let imageTap = UIGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2  
        profileImageView.clipsToBounds = true
        tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    @objc func openImagePicker(){
        self.present(imagePicker,animated: true, completion: nil)
    }//end of func
    
    @IBAction func backFromSU(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        guard let image = profileImageView.image else { return }
        
        if password.text != passwordConfirm.text {
        let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        }//end of if
        else{
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
            print("user created")
            if error == nil && user != nil{
            print("upload beginning")
            //upload here
                
                self.uploadProfileImage(image) { url in //this method does not run
                    print("upload does start")
                    print(url!)
                    if url != nil{
                    print("url does not equal nil")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                     changeRequest?.displayName = self.username.text!
                     changeRequest?.photoURL = url
                     changeRequest?.commitChanges { error in
                        print("made it below error in")
                         if error == nil{
                            print("made it below error == nil 1")
                            self.saveProfile(username: self.username.text!, profileImageURL: url!) { success in
                                print("made it above success")
                                if success {
                                    print("made it into success")
                                    self.performSegue(withIdentifier: "toOnboarding", sender: self)
                                    //self.dismiss(animated: true, completion: nil)
                                }//end of success if
                                else{
                               //     self.resetForm()
                                }
                                print("made it just above end of .saveprofile")
                            }//end of .saveProfile
                             
                            // self.dismiss(animated: true, completion: nil)
                         }//end of if
                        
                     }//end of changeRequest
                        
                    }//end of starting if
                    else {
                        //handle
                    }//end of else
                }//end of .uploadProfileImage
        }//end of if
        else{
           print(error)
           let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
           let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
               }
                    }
              }
        
    }//end of func
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url: URL?)->())){
        print("method does start")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in

            guard let metadata = metaData else { return }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
              guard let downloadURL = url else { return }
                if error == nil, metaData != nil{
                    completion(url)
                }
                else{
                    completion(nil)
                }//end of else
            }//end of .downloadUrl
            
        }//end of storage ref
    }//end of func
    
    func saveProfile(username: String, profileImageURL: URL, completion: @escaping ((_ success: Bool)->())){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username": username,
            "photoURL": profileImageURL.absoluteString
        ] as [String:Any]
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }//end of databaseRef
    }//end of func
    

}//end of class
extension SecondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }//end of func
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }//end of func
}//end of extension
