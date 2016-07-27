//
//  RQuestion.swift
//  G1
//
//  Created by Shawn on 2015-08-20.
//  Copyright (c) 2015 Shawn. All rights reserved.
//

import Foundation
import CoreData

class RQuestion: NSManagedObject {

    @NSManaged var choice: AnyObject
    @NSManaged var correct: NSNumber
    @NSManaged var image: NSData
    @NSManaged var isImage: NSNumber
    @NSManaged var selected: NSNumber
    @NSManaged var tag: NSNumber
    @NSManaged var text: String
    @NSManaged var sign: NSNumber

}
