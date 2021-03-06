//
//  TagDataSource.swift
//  FlickPhoto
//
//  Created by Tyler Jasper on 8/15/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import UIKit
import CoreData

class TagsDataSource: NSObject, UITableViewDataSource {
    
    var tags: [NSManagedObject] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let tag = tags[indexPath.row]
        let name = tag.value(forKey: "name") as! String
        cell.textLabel?.text = name
        
        return cell
    }
}
