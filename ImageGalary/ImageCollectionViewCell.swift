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
                spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                fetchImage()
            }
        }
    }
    
    var imageFetcher: ImageFetcher!
    
    var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
            spinner.center = imageView.center
            self.contentView.addSubview(spinner)
        }
    }
    
    private func fetchImage() {
        imageFetcher = ImageFetcher() {
            (url, image) in
            DispatchQueue.main.async { [weak self] in
                if url == self?.imageURL {
                    self?.imageView.image = image
                    self?.spinner.stopAnimating()
                }
            }
        }
        
        if let url = imageURL {
            imageFetcher.fetch(url)
        }
    }
}
