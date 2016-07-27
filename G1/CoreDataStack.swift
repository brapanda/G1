//
//  CoreDataStack.swift
//  G1
//
//  Created by Shawn on 2015-08-04.
//  Copyright (c) 2015 Shawn. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    let context: NSManagedObjectContext
    let psc: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let store: NSPersistentStore?
    
    class func applicationDocumentsDirectory() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as! [NSURL]
        return urls[0]
    }
    
    init() {
        //1
        let bundle = NSBundle.mainBundle()
        let modelURL = bundle.URLForResource("G1", withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        
        //2
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        //3
        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = psc
        
        //4
        let documentsURL = CoreDataStack.applicationDocumentsDirectory()
        let storeURL = documentsURL.URLByAppendingPathComponent("Question")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        
        var error: NSError?
        
        store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: &error)
        
        if store == nil{
            println("Cannot Save Data \(error)")
            abort()
        }
    }
    
    func saveContext() {
        var error : NSError?
        
        if context.hasChanges && !context.save(&error) {
            println("Cannot save \(error), \(error?.userInfo)")
        }
    }
    
    
}