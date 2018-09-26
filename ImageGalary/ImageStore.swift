//
//  ImageStore.swift
//  ImageGalary
//
//  Created by Wangshu Zhu on 2018/9/25.
//  Copyright © 2018年 Wangshu Zhu. All rights reserved.
//

import Foundation

struct ImageStore  {
    var imageURL: URL
    var cellRatio: Double
    
    init (url: URL, ratio: Double) {
        imageURL = url
        cellRatio = ratio
    }
    
}
