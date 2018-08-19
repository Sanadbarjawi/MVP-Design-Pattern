//
//  UploadFileModel.swift
//  MVPApp
//
//  Created by Sanad Barjawi on 8/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//


import Foundation

enum  UploadFileKey: String {
    case images = "images[%@]file"
    case video = "videos[%@]file"
}

struct UploadFileModel {
    var data: [Data?]
    var key: UploadFileKey
}
