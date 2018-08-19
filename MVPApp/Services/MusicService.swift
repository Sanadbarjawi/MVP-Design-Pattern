//
//  MusicService.swift
//  MVPApp
//
//  Created by Sanad Barjawi on 8/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class MusicService {
    
    var helper = APIHelper()
    func getMusicData(_ params:[String:Any], success: @escaping ([MusicModel])->Void, failure: @escaping (Error?)->Void){
        helper.getRequest(endPoint: URLPath.music, parameters: params, headers:["Authorization": "Bearer"]) { (data, _, error) in
            if error != nil {
                failure(error)
                return
            }
            guard let data = data else { return }
            do {
                let musicList = try JSONDecoder().decode([MusicModel].self, from: data)
                success(musicList)
            } catch {
                failure(error)
            }
        }
    }
}
