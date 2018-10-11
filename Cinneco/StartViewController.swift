//
//  StartViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 26/08/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class StartViewController: UIViewController {

    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("HELLO THIS IS START")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fbSignUpAction(_ sender: UIButton) {
        self.loginButtonClicked()
    }
    
    @objc func loginButtonClicked() {
        let loginManager = FBSDKLoginManager()
        
        loginManager.logIn(withReadPermissions: facebookReadPermissions, from: self) { (loginResult, error) in
            if error != nil {
                print("Error: ", error?.localizedDescription ?? "Login Failed")
            } else {
                if (loginResult?.isCancelled)! {
                    print("User has cancelled login")
                } else {
                    print("Login Successful: ", loginResult ?? "Login Unsuccessful")
                    self.getFBUserData()
                }
                
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print("Result: ", result ?? "Result is nil")
                    let dictionary = result as! [String: AnyObject]
                    let userId = dictionary["id"] as! String
                    let photoDict = ((dictionary["picture"] as! [String: AnyObject])["data"] as! [String: AnyObject])["url"] as! String
                    //print("UID: ", userId)
                    //print("Image Url: ", photoDict)
                    let email = dictionary["email"] as! String
                    let fullName = dictionary["name"] as! String
                    /*
                    let userDetails = ["username": "facebook", "fullName": fullName, "email": email]
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            self.stopSpinner()
                            
                            // alert with error description
                            print("Error-1", error.debugDescription)
                        } else {
                            self.stopSpinner()
                            DataService.instance.userRef.child(user!.uid).setValue(userDetails)
                            UserDefaults.standard.set(user?.uid, forKey: "UID")
                            //store user encoding in userdefaults
                            self.performSegue(withIdentifier: "signUpSegue", sender: self)
                        }
                    })
                    */
                    UserDefaults.standard.set(userId, forKey: "UID")
                    UserDefaults.standard.set(photoDict, forKey: "USER_PHOTO_URL")
                    
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                } else {
                    print("Error-2: ", error?.localizedDescription ?? "Can't get data")
                }
            })
        }
    }

    
}
