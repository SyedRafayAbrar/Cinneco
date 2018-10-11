//
//  ActorViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 12/05/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

class ActorViewController: UIViewController {

    @IBOutlet weak var seeAll_btn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
             seeAll_btn.semanticContentAttribute = .forceRightToLeft
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.title = "Actor"
    }
    


}

extension ActorViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath)
        return cell
    }
    
    
    
    
}
