//
//  PhotosViewController.swift
//  FlickPhoto
//
//  Created by Tyler Jasper on 8/10/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            OperationQueue.main().addOperation( {
                switch photosResult {
                case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                case let .Failure(error):
                    print("Error fetching recent photos \(error)")
                    self.photoDataSource.photos.removeAll()
                }
                self.collectionView.reloadSections(IndexSet(integer: 0))
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationViewController = segue.destinationViewController as! PhotoInfoViewController
                destinationViewController.photo = photo
                destinationViewController.store = store
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImageForPhoto(photo: photo, completion: {
            (result) -> Void in
            OperationQueue.main().addOperation() {
                
                let photoIndex = self.photoDataSource.photos.index(of: photo)!
                let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                
                if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                        cell.updateWithImage(image: photo.image)
                }
            }
        })
    }
    
    
}
