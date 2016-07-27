//
//  TestViewController.swift
//  G1
//
//  Created by Shawn on 2015-07-25.
//  Copyright (c) 2015 Shawn. All rights reserved.
//

import Foundation
import UIKit
class TestViewController: UIViewController,ZLSwipeableViewDataSource,ZLSwipeableViewDelegate,UIActionSheetDelegate{
    
    let screenSize : CGRect = UIScreen.mainScreen().bounds
    var swipeableView : ZLSwipeableView!
    var colors = NSArray()
    var colorIndex = 0
    
    func randomColor() -> UIColor{
        let red = arc4random_uniform(255)
        let blue = arc4random_uniform(255)
        let green = arc4random_uniform(255)
        return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorIndex = 0
        self.colors = [
            UIColor.flatAlizarinColor(),UIColor.flatAmethystColor(),UIColor.flatAsbestosColor(),UIColor.flatBelizeHoleColor(),UIColor.flatCarrotColor(),UIColor.flatCloudsColor(),UIColor.flatConcreteColor(),UIColor.flatEmeraldColor(),UIColor.flatGreenSeaColor(),UIColor.flatMidnightBlueColor(),UIColor.flatNephritisColor(),UIColor.flatOrangeColor(),UIColor.flatPeterRiverColor(),UIColor.flatPomegranateColor(),UIColor.flatPumpkinColor(),UIColor.flatSilverColor(),UIColor.flatSunFlowerColor(),UIColor.flatTurquoiseColor(),UIColor.flatWetAsphaltColor(),UIColor.flatWisteriaColor()]
            /*
        "Turquoise",
        "Green Sea",
        "Emerald",
        "Nephritis",
        "Peter River",
        "Belize Hole",
        "Amethyst",
        "Wisteria",
        "Wet Asphalt",
        "Midnight Blue",
        "Sun Flower",
        "Orange",
        "Carrot",
        "Pumpkin",
        "Alizarin",
        "Pomegranate",
        "Clouds",
        "Silver",
        "Concrete",
        "Asbestos"
        ]*/
        swipeableView = ZLSwipeableView(frame: CGRect(x: 30, y: 50, width: screenSize.size.width - 60, height: screenSize.size.height - 120))
        self.view.addSubview(swipeableView)
        self.swipeableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        self.swipeableView.dataSource = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextViewForSwipeableView(swipeableView: ZLSwipeableView!) -> UIView! {
        if (self.colorIndex < self.colors.count){
            var cardView = CardView(frame: swipeableView.bounds)
            cardView.backgroundColor = self.colors[colorIndex] as! UIColor
            self.colorIndex++
            
            var textView = UITextView(frame: cardView.bounds)
            textView.text = "test"
            textView.backgroundColor = UIColor.clearColor()
            textView.font = UIFont.systemFontOfSize(24)
            textView.editable = false
            textView.selectable = false
            cardView.addSubview(textView)
            
            return cardView
        }
        return nil
    }
    /*
    func colorForName(name: NSString) -> UIColor{
        let sanitizedName = name.stringByReplacingOccurrencesOfString(" ", withString: "")
        let selectorString = NSString(format: "flat\(sanitizedName)Color", arguments: sanitizedName)
        let selector = "flat\(sanitizedName)Color"
        let colorClass = UIColor.classForKeyedUnarchiver(selector)
        return UIColor.performSelector(Selector(selector), withObject: nil) as! UIColor
    }
    */
}