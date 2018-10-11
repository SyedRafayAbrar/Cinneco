//
//  SettingsViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 04/11/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKShareKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FBSDKAppInviteDialogDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let sectionTitles = ["INVITE", "FOLLOW PEOPLE", "ACCOUNT", "OTHER"]
    
    let sectionZero = ["Facebook Friends","Contacts"]
    let sectionOne = ["Facebook Friends"]
    let sectionTwo = ["Edit Profile", "Change Password"]
    let sectionThree = ["Talk To Us", "Rate This App", "Tell A Friend", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //change status bar color
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 4 {
            return ""
        } else {
            return sectionTitles[section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 4 {
            return 0.0
        } else if section == 0 {
            return 26.0
        } else {
            return 24.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 {
            return 0.0
        } else {
            return 5.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 15.0)!
        header.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 150.0
        } else {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionZero.count
        case 1:
            return sectionOne.count
        case 2:
            return sectionTwo.count
        case 3:
            return sectionThree.count
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 4 {
            let logoCell = tableView.dequeueReusableCell(withIdentifier: "logoCell")
            return logoCell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let settingItemTitleLbl = cell?.viewWithTag(10) as! UILabel
            
            switch indexPath.section {
            case 0:
                settingItemTitleLbl.text = sectionZero[indexPath.row]
            case 1:
                settingItemTitleLbl.text = sectionOne[indexPath.row]
            case 2:
                settingItemTitleLbl.text = sectionTwo[indexPath.row]
            case 3:
                settingItemTitleLbl.text = sectionThree[indexPath.row]
            default:
                break
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                //self.performSegue(withIdentifier: "inviteFbFriendsSegue", sender: self)
                inviteFbFriendsAction()
            case 1:
                //self.performSegue(withIdentifier: "inviteContactsSegue", sender: self)
                inviteContactsAction()
            default:
                break
            }
        } else if indexPath.section == 1 {
            self.performSegue(withIdentifier: "followFbFriendsSegue", sender: self)
            //followFbFriendsAction()
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "editProfileSegue", sender: self)
            case 1:
                self.performSegue(withIdentifier: "changePwdSegue", sender: self)
            default:
                break
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "talkToUsSegue", sender: self)
            case 1:
                rateAppAction()
            case 2:
                shareAppAction()
            case 3:
                logoutAction()
            default:
                break
            }
        }
    }
    
    func logoutAction() {
        print("Logout")
        UserDefaults.standard.removeObject(forKey: "UID")
        
        try! Auth.auth().signOut()
        //Back to login screen
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "startVc")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
    
    func shareAppAction() {
        print("Share App")
        let url = URL(string: "https://www.google.com.pk/")
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out this Social Network for Movie Lovers", url],
            applicationActivities: nil)
//        if let popoverPresentationController = activityViewController.popoverPresentationController {
//            popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
//        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func rateAppAction() {
        print("Rate App")
    }
    
    //Mark: FB Invite SDK delegates
    func inviteFbFriendsAction() {
        print("Invite Facebook Friends")
        let inviteDialog: FBSDKAppInviteDialog = FBSDKAppInviteDialog()
        if(inviteDialog.canShow()){
            
            //let appLinkUrl = URL(string: "https://itunes.apple.com/us/app/cinneco/id1308359245?ls=1&mt=8")!
            //let appLinkUrl = URL(string: "https://fb.me/701512093381949")!
            let appLinkUrl = URL(string: "https://fb.me/701543233378835")!
            
            let previewImageUrl = URL(string: "https://images-na.ssl-images-amazon.com/images/I/21%2BOVqzNo7L.png")!
            
            let inviteContent: FBSDKAppInviteContent = FBSDKAppInviteContent()
            inviteContent.appLinkURL = appLinkUrl
            inviteContent.appInvitePreviewImageURL = previewImageUrl
            
            inviteDialog.content = inviteContent
            inviteDialog.delegate = self
            inviteDialog.show()
        }
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        let resultObject = NSDictionary(dictionary: results) //remove from here, will crash
        print("Result: ", results)
        if let didCancel = resultObject.value(forKey: "completionGesture") {
            if (didCancel as AnyObject).caseInsensitiveCompare("Cancel") == ComparisonResult.orderedSame {
                print("User Canceled invitation dialog")
            }
        }
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("Invite Error: ", error.localizedDescription)
    }
    
    func inviteContactsAction() {
        print("Invite Contacts")
        self.performSegue(withIdentifier: "inviteAllContactsSegue", sender: self)
    }
}
