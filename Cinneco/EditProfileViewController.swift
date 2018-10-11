//
//  EditProfileViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 27/04/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EditProfileViewController: UIViewController, UITextViewDelegate {
    
    var user : User!
    
    var username = ""
    var bio = ""
    var location = ""
    var website = ""
    var imageStorageURL : String? = ""
    
    let imagePicker = UIImagePickerController()
    
    
    /// LABELS :-
    @IBOutlet weak var profile_view: UIImageView!
    @IBOutlet weak var edit_view: UIView!
    @IBOutlet weak var layer_view: UIView!
    @IBOutlet weak var text_area: UITextView!
    @IBOutlet weak var name_textfeild: UITextField!
    
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var location_textfeild: UITextField!
    @IBOutlet weak var webiste_textfeild: UITextField!
    
    
    /// Outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    fileprivate func SetupProfileView() {
        profile_view.layer.borderWidth = 1
        profile_view.layer.masksToBounds = false
        profile_view.layer.borderColor = UIColor.black.cgColor
        profile_view.layer.cornerRadius = profile_view.frame.height/2
        profile_view.clipsToBounds = true
       
        
        
        text_area.textColor = UIColor.white
        text_area.delegate = self
        text_area.text = "Add a bio to your profile"
        text_area.textColor = UIColor.lightGray
        text_area.font = UIFont(name: "SF Mono", size: 12)
        
        edit_view.makeCircular()
        layer_view.makeCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        // Setup Profile
        SetupProfileView()
        
        // Get user from profile
        getUserData()
    }
    
    
    
    /// Save Profile
    @IBAction func savePressed(_ sender: Any) {
        imageUploadFirebase()
    }
    
    
    /// Image Upload to firebase
    func imageUploadFirebase() {
        self.startSpinner()
        let imageData = UIImageJPEGRepresentation(self.profile_view.image!, 0.1)
        let imageName = "\(arc4random()).png"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(imageName)
        let uploadTask = imageRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            guard (error == nil) else {
                print(error!.localizedDescription)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("Image URL Firebase: \(downloadURL)")
                self.stopSpinner()
                self.imageStorageURL = "\(downloadURL)"
                self.saveProfile()
            }
            print("Failed to save get the download URL from firebase")
        }
    }
    
    
    // Save profile to firebase
    func saveProfile() {
        self.startSpinner()
                let profileData = ["bio": "\(name_label.text!)", "website": "\(webiste_textfeild.text!)", "location": "\(location_textfeild.text!)" , "imageURL": "\(imageStorageURL!)"]
        
        print("Dic to upload \(profileData)")
        
        DataService.instance.currentUserRef.updateChildValues(profileData) { (error, result) in
            
            guard (error == nil) else {
                print(error!.localizedDescription)
                return
            }
            
            print("Sucessfully saved data in profile")
            self.stopSpinner()
            self.alert(title: "Success", message: "Profile saved sucessfully")
        }
    }
    
    
    
    
    
   
    // Get user data of the user
    func getUserData() {
        self.startSpinner()
        DataService.instance.currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.username = dictionary["username"] as! String
            self.bio = dictionary["bio"] as? String ?? "Enter your bio"
            self.location = dictionary["location"] as? String ?? "Enter your location"
            self.website = dictionary["website"] as? String ?? "Enter your websiste"
            self.imageStorageURL = (dictionary["imageURL"] as? String)!
            
            print("UserName: \(self.username)")
            print("Bio: \(self.bio)")
            print("Location: \(self.location)")
            print("Website: \(self.website)")
            print("Image URL: \(self.imageStorageURL!)")
            
            
            // Set textfeids
            self.text_area.text = self.bio
            self.name_label.text = self.username
            self.location_textfeild.text = self.location
            self.webiste_textfeild.text = self.website
            
            self.stopSpinner()
            
            if let profileImagePath = self.imageStorageURL {
                let imgUrl = URL(string: "\(profileImagePath)")
//                print(imgUrl)
                self.profile_view.kf.setImage(with:imgUrl, placeholder: #imageLiteral(resourceName: "profile-ph"), options: nil, progressBlock: nil, completionHandler: nil)
                
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if text_area.textColor == UIColor.lightGray {
            text_area.text = ""
            text_area.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text_area.text == "" {
            text_area.text = "Add a bio to your profile"
            text_area.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func editImagePressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func startSpinner() {
        self.spinner.startAnimating()
        self.spinner.isHidden = false
        self.view.isUserInteractionEnabled = false
    }
    
    func stopSpinner() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
    
}


// MARK: - PickerView Delegate and Datasource methods

extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            profile_view.contentMode = .scaleAspectFit5
            profile_view.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}
extension UIView {
    
    @IBInspectable var KornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var baorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var baorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
}







