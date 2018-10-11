//
//  ReviewViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 26/04/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    
    @IBOutlet weak var topview_height: NSLayoutConstraint!
    
    @IBOutlet weak var show_review_btn: UIButton!
    @IBOutlet weak var profile_image: UIImageView!
    
    
    @IBOutlet weak var review_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var background_image: UIImageView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
//        topview_height.constant =  620
        background_image.addBlurEffect()
        
        profile_image.layer.borderWidth = 1
        profile_image.layer.masksToBounds = false
        profile_image.layer.borderColor = UIColor.black.cgColor
        profile_image.layer.cornerRadius = profile_image.frame.height/2
        profile_image.clipsToBounds = true
        
//        show_review_btn.semanticContentAttribute = .forceRightToLeft
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func show(_ sender: Any) {
        if (review_view.isHidden) {
            review_view.isHidden = false
//            topview_height.constant = 900
            show_review_btn.setTitle("Hide Review    ", for: .normal)
//            show_review_btn.setImage("arrow-down", for: .normal)
//            show_review_btn.setImage("arrow-up1", for: .norma)
            show_review_btn.setImage(UIImage(named: "arrow-up"), for: .normal)
            
            
        }
        else {
            review_view.isHidden = true
//            topview_height.constant = 600
            show_review_btn.setTitle("Show Review    ", for: .normal)
//            show_review_btn.setImage("arrow-up", for: .normal)
             show_review_btn.setImage(UIImage(named: "arrow-down"), for: .normal)
        }
      
    }
    
    @IBAction func back_buton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true
        )
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UIViewController-cAq-JN-2AG") as! HomeViewController
//        present(vc, animated: true, completion: nil)
        
//        self.dismiss(animated: true, completion: nil)
//        self.performSegue(withIdentifier: "back", sender: self)
        
    }
    
    

}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell", for: indexPath) as! ReviewTableViewCell
            cell.comment_image.layer.borderWidth = 1
        cell.comment_image.layer.masksToBounds = false
        cell.comment_image.layer.borderColor = UIColor.black.cgColor
        cell.comment_image.layer.cornerRadius = cell.comment_image.frame.height/2
     
        cell.comment_image.clipsToBounds = true
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116.0
    }
}
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
