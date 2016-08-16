//
//  Photo+CoreDataClass.swift
//  FlickPhoto
//
//  Created by Tyler Jasper on 8/12/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import UIKit
import CoreData


public class Photo: NSManagedObject {

    var image: UIImage?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        title = ""
        photoID = ""
        remoteURL = NSURL() as URL
        photoKey = NSUUID().uuidString
        dateTaken = NSDate() 
    }
    
    func addTageObject(tag: NSManagedObject) {
        let currentTags = mutableSetValue(forKey: "tags")
        currentTags.add(tag)
    }
    
    func removeTagObjects(tag: NSManagedObject) {
        let currentTags = mutableSetValue(forKey: "tags")
        currentTags.remove(tag)
    }
}
