//
//  TagsViewController.swift
//  FlickPhoto
//
//  Created by Tyler Jasper on 8/15/16.
//  Copyright © 2016 Tyler Jasper. All rights reserved.
//

import UIKit
import CoreData

class TagsViewController: UITableViewController {
    var store: PhotoStore!
    var photo: Photo!
    
    var selectedIndex = [NSIndexPath]()
    let tagsDataSource = TagsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tagsDataSource
        tableView.delegate = self
        updateTags()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = tagsDataSource.tags[indexPath.row]
        
        if let index = selectedIndex.index(of: indexPath) {
            selectedIndex.remove(at: index)
            photo.removeTagObjects(tag: tag)
        } else {
            selectedIndex.append(indexPath)
            photo.addTageObject(tag: tag)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        do {
            try store.coreDataStack.saveChanges()
        } catch let error {
            print("Core data failed to save: \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedIndex.index(of: indexPath) != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewTag(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Tag", message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "tag name"
            textField.autocapitalizationType = .words
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) -> Void in
            
            if let tagName = alertController.textFields?.first?.text {
               let context = self.store.coreDataStack.mainQueueContext
                let newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: context)
                newTag.setValue(tagName, forKey: "name")
                
                do {
                    try self.store.coreDataStack.saveChanges()
                } catch let error {
                    print("Core data save failed \(error)")
                }
                self.updateTags()
                self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
            }
        })
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateTags() {
        let tags = try! store.fetchMainQueueTags(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        tagsDataSource.tags = tags
        
        for tag in photo.tags {
            if let index = tagsDataSource.tags.index(of: tag) {
                let indexPath = IndexPath(row: index, section: 0)
                selectedIndex.append(indexPath)
            }
        }
    }
    
}
