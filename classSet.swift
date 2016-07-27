//
//  classSet.swift
//  G1
//
//  Created by Shawn on 2015-08-02.
//  Copyright (c) 2015 Shawn. All rights reserved.
//

import Foundation
import UIKit

class question: NSObject {
    var text : NSString?
    var correct : Int = 0
    var isImage : Bool = false
    var tag : Int = 0
    var choice: Choice = Choice()
    var image: NSString?
}

class Choice : NSObject {
    var choiceA : String?
    var choiceB : String?
    var choiceC : String?
    var choiceD : String?
}

