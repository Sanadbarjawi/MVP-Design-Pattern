//
//  DownloadsDataPresenter.swift
//  MVPApp
//
//  Created by Sanad Barjawi on 8/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//
import Foundation

protocol DataView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setPosts(_ music: [DataModel])
    func setError(_ error: Error?)
    func endRefreshing()
    func setEmptyView()
}

class DataPresenter {
    private let dataService: DataService
    weak private var dataView: DataView?
    
    private var dataList = [DataModel]()
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    func attachView(_ view:DataView){
        dataView = view
    }
    
    func detachView(){
        dataView = nil
    }
    
    func getData(_ dataId:Int){
        self.dataView?.startLoading()
        let params = ["dataId":dataId]
        dataService.getData(params, success: { [weak self] dataList in
            self?.dataView?.finishLoading()
            self?.dataList.append(contentsOf: dataList)
            if self?.dataList.isEmpty ?? false{
                self?.dataView?.setEmptyView()
                return
            }
            self?.dataView?.setPosts(dataList)
            }, failure: { [weak self] error in
                self?.dataView?.finishLoading()
                self?.dataView?.setError(error)
        })
    }

    func getDataCount()->Int{
        return self.dataList.count
    }
    func getData(_ indexPath: IndexPath) -> DataModel{
        return self.dataList[indexPath.row]
    }
    func clearDataList(){
        self.dataList = [DataModel]()
    }
    func dataListIsEmpty() -> Bool {
        return self.dataList.isEmpty
    }
}

