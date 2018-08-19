//
//  MusicService.swift
//  MVPApp
//
//  Created by Sanad Barjawi on 8/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class DataService {
    
    var helper = APIHelper()
    func getData(_ params:[String:Any], success: @escaping ([DataModel])->Void, failure: @escaping (Error?)->Void){
        helper.getRequest(endPoint: URLPath.music, parameters: params, headers:["Authorization": "Bearer"]) { (data, _, error) in
            if error != nil {
                failure(error)
                return
            }
            guard let data = data else { return }
            do {
                let musicList = try JSONDecoder().decode([DataModel].self, from: data)
                success(musicList)
            } catch {
                failure(error)
            }
        }
    }
}
