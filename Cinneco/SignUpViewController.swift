//
//  SignUpViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 26/08/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class SignUpViewController: UIViewController {
    @IBOutlet weak var backBtnStackView: UIStackView!
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBOutlet weak var userNameTxtFld: CustomTextField!
    @IBOutlet weak var fullNameTxtFld: CustomTextField!
    @IBOutlet weak var emailTxtFld: CustomTextField!
    @IBOutlet weak var passwordTxtFld: CustomTextField!
    @IBOutlet weak var confirmPwdTxtFld: CustomTextField!
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.stopSpinner()
    }
    
    @IBAction func createAccAction(_ sender: UIButton) {
        self.startSpinner()
        if let userName = userNameTxtFld.text, !userName.isEmpty, let fullName = fullNameTxtFld.text, !fullName.isEmpty, let email = emailTxtFld.text, !email.isEmpty, let password = passwordTxtFld.text, !password.isEmpty, let confirmPwd = confirmPwdTxtFld.text, !confirmPwd.isEmpty {
            if password == confirmPwd {
                let userDetails = ["username": userName, "fullName": fullName, "email": email]
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.stopSpinner()
                        
                        // alert with error description
                        print("Error-1", error.debugDescription)
                        self.handleError(error!)
                    } else {
//                        UserDefaults.standard.set(user?.uid, forKey: "UID")
//                        DataService.instance.userRef.child(user!.uid).setValue(userDetails, withCompletionBlock: { (error, reference) in
//                            UserDefaults.standard.set(userName, forKey: "USERNAME")
//                            self.stopSpinner()
//                            self.performSegue(withIdentifier: "signupSegue", sender: self)
//                        })
                        //store user encoding in userdefaults
                    }
                })
            } else {
                self.stopSpinner()
                // alert pwd do not match
                print("Error-2")
                alert(title: "Error", message: "Password you have entered donot match")
                
            }
        } else {
            //some feilds are missing
             self.stopSpinner()
           alert(title: "Error", message: "Some feilds are missing")
        }
        
    }

    @IBAction func gotoSignInVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startSpinner() {
        self.spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopSpinner() {
        self.spinner.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
}
