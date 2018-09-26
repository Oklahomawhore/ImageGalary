//
//  ImageCollectionViewCell.swift
//  ImageGalary
//
//  Created by Wangshu Zhu on 2018/9/21.
//  Copyright © 2018年 Wangshu Zhu. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var imageView: ImageView!
    
    var imageURL: URL? {
        didSet {
            if imageURL != nil {
                fetchImage()
            }
        }
    }
    
    var imageFetcher: ImageFetcher!
    
    private func fetchImage() {
        imageFetcher = ImageFetcher() {
            (url, image) in
            DispatchQueue.main.async { [weak self] in
                if url == self?.imageURL {
                    self?.imageView.image = image
                }
            }
        }
        if let url = imageURL {
            imageFetcher.fetch(url)
        }
    }
}
