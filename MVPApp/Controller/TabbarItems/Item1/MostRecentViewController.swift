//
//  MostRecentViewController.swift
//  MVPApp
//
//  Created by Sanad Barjawi on 8/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import UIKit

class MostRecentViewController: UIViewController {
    @IBOutlet weak var item2Btn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func item2BtnPressed(_ sender: Any) {
        
        let item2TabbarStoryboard = UIStoryboard(name: "Item2Tabbar", bundle: nil)
        let mostRecentVC = item2TabbarStoryboard.instantiateViewController(withIdentifier: "DownloadsViewController") as! DownloadsViewController
        navigationController?.pushViewController(mostRecentVC, animated: true)
    
    }
    

}
