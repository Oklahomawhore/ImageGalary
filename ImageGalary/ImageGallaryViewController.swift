//
//  ImageGallaryViewController.swift
//  ImageGalary
//
//  Created by Wangshu Zhu on 2018/9/21.
//  Copyright © 2018年 Wangshu Zhu. All rights reserved.
//

import UIKit

class ImageGallaryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout
{
    //MARK: stored properties
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.dragDelegate = self
            collectionView.dropDelegate = self
            collectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:))))
        }
    }
    
    private var imageURLs: [URL] = [URL]()
    private var cellRatios = [Double]()
    private var images: [ImageStore]  = [ImageStore]()
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.spinner.isHidden = false
            imageCell.spinner.startAnimating()
            imageCell.imageURL = images[indexPath.item].imageURL
        }
    }
    
    @objc func pinchAction(_ sender: UIPinchGestureRecognizer) {
        if sender.view == collectionView {
            switch sender.state {
            case .changed:
                fixedWidth = Double(sender.scale) * fixedWidth
            case .ended:
                break
            default:
                break
            }
        }
    }
    
    //MARK: - collectionview data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    var cellImageFetcher: ImageFetcher!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.imageURL = images[indexPath.item].imageURL
        }
        if indexPath.item == 5 {
            print("there are 5 items here")
        }
        return cell
    }
    
    //MARK: - collectionView flow layout
    private var fixedWidth: Double = 300 {
        didSet {
            collectionView.setNeedsLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < images.count {
            return CGSize(width: fixedWidth, height: fixedWidth * images[indexPath.item].cellRatio)
        } else {
            return CGSize.zero
        }
    }
    
    //MARK: - collectionview drag delegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        let item = images[indexPath.item]
        let dragItem = UIDragItem(itemProvider: NSItemProvider(contentsOf: item.imageURL)!)
        return [dragItem]
    }
    //MARK: - collectionview drop delegate
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    var imageFectcher: ImageFetcher!
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                coordinator.session.localDragSession?.localContext
            } else {
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "PlaceholderCell"))
                var cellRatio: Double = 1.0
                
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error)  in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            cellRatio = Double( image.size.height / image.size.width )
                        }
                    }
                    
                }
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL {
                            placeholderContext.commitInsertion(dataSourceUpdates: { (insertionIndexPath) in
                                self.images.insert(ImageStore(url: url, ratio: cellRatio), at: insertionIndexPath.item)
                                print("\(insertionIndexPath.debugDescription)")
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                    
                }
                
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
