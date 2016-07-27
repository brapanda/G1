//
//  selectionItem.swift
//  G1
//
//  Created by Shawn on 2015-07-27.
//  Copyright (c) 2015 Shawn. All rights reserved.
//

import Foundation

class selectionItem: UIButton{
    var _selectionNum : NSInteger!
    var _text : String!
    var _isSignQuestion = false
    var _answers : NSArray!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = CGRect(x: 20, y: 0, width: 100, height: 100)
    }
    /*
    init(selectionNum: NSInteger, text: String, isSignQuestion: Bool, answers: NSArray){
        _selectionNum = selectionNum
        _text = text
        _isSignQuestion = isSignQuestion
        _answers = answers
    }
    */

}