//
//  PhotoInfoViewController.swift
//  FlickPhoto
//
//  Created by Tyler Jasper on 8/11/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo: photo, completion: {
            (result) -> Void in
            switch result {
            case let .Success(image):
                OperationQueue.main.addOperation() {
                    self.imageView.image = image
                }
            case let .Failure(error):
                print("Error fetching image for Photo: \(error)")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTags" {
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            
            tagController.store = store
            tagController.photo = photo 
        }
    }
}
