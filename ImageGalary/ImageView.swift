//
//  ImageView.swift
//  ImageGalary
//
//  Created by Wangshu Zhu on 2018/9/23.
//  Copyright © 2018年 Wangshu Zhu. All rights reserved.
//

import UIKit

class ImageView: UIView {
    var image: UIImage! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if image != nil {
            image.draw(in: bounds)

        }
    }
    
}
