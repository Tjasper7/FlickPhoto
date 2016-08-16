//
//  ImageStore.swift
//  YourHomeStuff
//
//  Created by Tyler Jasper on 8/8/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache<AnyObject, AnyObject>()
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
        let imageURL = imageURLForKey(key: key)
        
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            try! data.write(to: imageURL as URL, options: .atomicWrite)
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey:key) as? UIImage {
            return existingImage
        }
        let imageUrl = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageUrl.path!) else {
            return nil
        }
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key)
        
        let imageUrl = imageURLForKey(key: key)
        do {
        try FileManager.default.removeItem(at: imageUrl as URL)
        } catch  let deleteError {
            print("Error removing image from disk: \(deleteError)")
        }
    }
    
    func imageURLForKey(key: String) -> NSURL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
    
}
