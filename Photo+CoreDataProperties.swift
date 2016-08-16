//
//  Photo+CoreDataProperties.swift
//  FlickPhoto
//
//  Created by Tyler Jasper on 8/12/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import Foundation
import CoreData

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var title: String
    @NSManaged public var photoID: String
    @NSManaged public var photoKey: String
    @NSManaged public var remoteURL: URL
    @NSManaged public var dateTaken: NSDate
    @NSManaged public var tags: Set<NSManagedObject>

}
