//
//  LoginViewController.swift

//  Cinneco
//
//  Created by Asher Ahsan on 26/08/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FBSDKLoginKit
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBOutlet weak var userNameTxtFld: CustomTextField!
    @IBOutlet weak var pwdTxtFld: CustomTextField!
    
    var firebaseUserId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.stopSpinner()
    }
    
    @IBAction func facebookSignIn(_ sender: UIButton) {
        self.startSpinner()
        
        let loginManager = LoginManager()
        loginManager.loginBehavior = .native
        
        loginManager.logIn(readPermissions: [.publicProfile], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    // User is signed in
                    self.firebaseUserId = user?.uid
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    self.saveUserOnFirebase(user: dict)
                }
            })
        }
    }
    
    func saveUserOnFirebase(user: [String : AnyObject]) {
        let name = user["name"]
        let id = user["id"]
        let userData = ["name": name, "id": id]
        print("User data: ", userData)
        DataService.instance.userRef.child(firebaseUserId).setValue(userData) { (error, reference) in
            if error != nil {
                //show error alert
                print("Error: ", error.debugDescription)
            }
            print("Error: ", error)
            print("Reference: ", reference)
            
            UserDefaults.standard.set("USER", forKey: "USER")
            self.stopSpinner()
        }
        
        self.performSegue(withIdentifier: "loggedInSegue", sender: self)
    }
    
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        self.startSpinner()
        if let userName = userNameTxtFld.text, !userName.isEmpty, let password = pwdTxtFld.text, !password.isEmpty {
            Auth.auth().signIn(withEmail: userName, password: password, completion: { (user, error) in
                if error != nil {
                    self.stopSpinner()
                    print("Error: ", error.debugDescription)
                    self.handleError(error!)
                    //alert - error description
                } else {
                    //                    guard let uid = user?.uid else { return }
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    UserDefaults.standard.set(uid, forKey: "UID")
                    
                    //TEMPORARY
                    //UserDefaults.standard.set(self.user?.uid, forKey: "UID")
                    DataService.instance.currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dictionary = snapshot.value as? [String: AnyObject] else {
                            return
                        }
                        
                    print(dictionary)
                        let username = dictionary["username"] as! String
                        let fullname = 
                        self.stopSpinner()
                        UserDefaults.standard.set(username, forKey: "USERNAME")
                        self.performSegue(withIdentifier: "loggedInSegue", sender: self)
                    })
                    
                    
                }
            })
        } else {
            // error alert
            self.stopSpinner()
            alert(title: "Error", message: "Some feilds are missing")
        }
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

extension UIViewController {
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = .black
        let someAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(someAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        default:
            return "Unknown error occurred"
        }
    }
}


extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            alert.view.tintColor = .black
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}

