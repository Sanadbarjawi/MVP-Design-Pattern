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
    fileprivate var dataPresenter: DataPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataPresenter = DataPresenter(dataService: DataService())
        dataPresenter.attachView(self)
    }
    @IBAction func item2BtnPressed(_ sender: Any) {
        
        let item2TabbarStoryboard = UIStoryboard(name: "Item2Tabbar", bundle: nil)
        let mostRecentVC = item2TabbarStoryboard.instantiateViewController(withIdentifier: "DownloadsViewController") as? DownloadsViewController
        navigationController?.pushViewController(mostRecentVC!, animated: true)
    
    }
    
}
extension MostRecentViewController: DataView {
    func startLoading() {
        print("asdf")
    }
    
    func finishLoading() {
        print("asdf")
    }
    
    func setPosts(_ music: [DataModel]) {
        print("asdf")
    }
    
    func setError(_ error: Error?) {
        print("asdf")
    }
    
    func endRefreshing() {
        print("asdf")
    }
    
    func setEmptyView() {
        print("asdf")
    }
    
}
