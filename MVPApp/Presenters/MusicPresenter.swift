//
//  DownloadsDataPresenter.swift
//  MVPApp
//
//  Created by Sanad Barjawi on 8/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//
import Foundation

protocol MusicView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setPosts(_ music: [MusicModel])
    func setError(_ error: Error?)
    func endRefreshing()
    func setEmptyView()
}

class MusicPresenter {
    private let musicService: MusicService
    weak private var musicView: MusicView?
    
    private var musicList = [MusicModel]()
    
    init(musicService: MusicService) {
        self.musicService = musicService
    }
    func attachView(_ view:MusicView){
        musicView = view
    }
    
    func detachView(){
        musicView = nil
    }
    
    func getMusic(_ musicId:Int){
        self.musicView?.startLoading()
        let params = ["musicId":musicId]
        musicService.getMusicData(params, success: { [weak self] musicList in
            self?.musicView?.finishLoading()
            self?.musicList.append(musicList)
            if self?.musicList.isEmpty ?? false{
                self?.musicView?.setEmptyView()
                return
            }
            self?.musicView?.setPosts(musicList)
            }, failure: { [weak self] in
                self?.musicView?.finishLoading()
                self?.musicView?.setError(error)
        })
    }
    func getMusicCount()->Int{
        return self.musicList.count
    }
    func getMusicData(_ indexPath: IndexPath) -> MusicModel{
        return self.musicList[indexPath.row]
    }
    func clearMusicList(){
        self.musicList = [MusicModel]()
    }
    func musicListIsEmpty() -> Bool {
        return self.musicList.isEmpty
    }
}

