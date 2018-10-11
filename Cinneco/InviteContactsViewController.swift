//
//  InviteContactsViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/11/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class InviteContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let contactStore = CNContactStore()
    var sortedContacts = [CNContact]()
    var searchedContacts = [CNContact]()
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        
        requestContactAccess { (accessGranted) in
            if accessGranted {
                print("Contact Access allowed")
                self.sortedContacts = self.getContacts()
                DispatchQueue.main.async {
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
            } else {
                print("Contact Access not allowed")
            }
        }
        
    }

    @IBAction func inviteBtnAction(_ sender: UIButton) {
        var contactNumber = [String]()
        let contact: CNContact!
        
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        
        if searchActive {
            contact = searchedContacts[(indexPath?.row)!]
            contact.phoneNumbers.forEach({ (cnNumbers) in
                contactNumber.append(cnNumbers.value.stringValue)
            })
        } else {
            contact = sortedContacts[(indexPath?.row)!]
            contact.phoneNumbers.forEach({ (cnNumbers) in
                contactNumber.append(cnNumbers.value.stringValue)
            })
        }
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Check out this social network app Cinneco for movie lovers https://www.google.com"
            controller.recipients = contactNumber
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            print("Something went wrong.")
        }
    }
    
    func requestContactAccess(completion: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
        case .authorized:
            completion(true)
        case .notDetermined, .denied:
            self.contactStore.requestAccess(for: .contacts, completionHandler: { (access, error) in
                if access {
                    completion(access)
                } else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        print("Please allow the app to access your contacts through the Settings.")
                    }
                }
            })
        default:
            completion(false)
        }
    }
    
    func getContacts() -> [CNContact] {
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                           CNContactPhoneNumbersKey] as [Any]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        var contacts = [CNContact]()
        
        do {
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                contacts.append(contact)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        sortedContacts = contacts.sorted { $0.givenName < $1.givenName }
        return sortedContacts
    }
    
    
    //Mark: Search bar delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchText.isEmpty) {
            searchActive = true
            searchedContacts = sortedContacts.filter({ (contact) -> Bool in
                if contact.givenName.lowercased().contains(searchText.lowercased()) || contact.familyName.lowercased().contains(searchText.lowercased()) {
                    return true
                } else {
                    return false
                }
            })
            self.tableView.reloadData()
        } else {
            self.searchedContacts.removeAll()
            searchActive = false
            self.tableView.reloadData()
        }
    }
    
    //Mark: Tableview data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return self.searchedContacts.count
        } else {
            return self.sortedContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")
        let nameLbl = cell?.viewWithTag(5) as! UILabel
        
        if searchActive {
            let contact = (self.searchedContacts[indexPath.row])
            nameLbl.text = "\(contact.givenName) \(contact.familyName)"
        } else {
            let contact = (self.sortedContacts[indexPath.row])
            nameLbl.text = "\(contact.givenName) \(contact.familyName)"
        }
        
        return cell!
    }
    
    //Mark: Message Delegates
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
}
