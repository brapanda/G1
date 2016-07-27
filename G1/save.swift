//
//  selfTestViewController.swift
//  G1
//
//  Created by Shawn on 2015-07-27.
//  Copyright (c) 2015 Shawn. All rights reserved.
//
/*




//
//  selfTestViewController.swift
//  G1
//
//  Created by Shawn on 2015-07-27.
//  Copyright (c) 2015 Shawn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class selfTestViewController: UIViewController,UIActionSheetDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var managedContext: NSManagedObjectContext! = CoreDataStack().context
    let screenSize : CGRect = UIScreen.mainScreen().bounds
    var storyScrollView : JT3DScrollView!
    var navigationBar : UINavigationBar!
    var questionCompleted : UILabel!
    var overView: UIView!
    var totalCorrectView : UIButton!
    var overCollectionView : UICollectionView!
    var cardViewColor = UIColor.whiteColor()
    var currentQuestion : Int = 1
    var totalQuestion : Int = 0
    var totalCorrectAns : Int = 0
    var totalCorrect : UILabel!
    var alreadyLoad = [Int]()
    var sampleData = NSDictionary()
    var correctList = [Int: Int]()
    var questionSet = NSMutableArray()
    var QuestionsSet = [NSManagedObject]()
    var choiceSet = ["a.png","b.png","c.png","d.png"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.storyScrollView = JT3DScrollView(frame: CGRect(x: 25, y: 80, width: screenSize.width - 50, height: screenSize.height - 150))
        self.storyScrollView.effect = JT3DScrollViewEffect.Carousel
        self.storyScrollView.delegate = self
        
        /*
        let answer1 = ["text": "问题1", "isImage": false, "tag": 1, "image": "","choice": ["choiceA":"ans 1 abcdefb你好吗 小澜 ", "choiceB":"ans 2  ans 1 abcdefb你好吗 小澜 ","choiceC": "ans 3", "choiceD":"ans 4"], "correct": 2]
        
        let answer2 = ["text": "问题2", "isImage": true, "tag": 12, "image": "style.jpeg","choice": ["choiceA":"ans 1 abcdefb你好吗 小澜 ", "choiceB":"ans 2  ans 1 abcdefb你好吗 小澜 ","choiceC": "ans 3", "choiceD":"ans 4"], "correct": 1]
        
        let answer3 = ["text": "问题3", "isImage": false, "tag": 33, "image": "","choice": ["choiceA":"ans 1 abcdefb你好吗 小澜 ", "choiceB":"ans 2  ans 1 abcdefb你好吗 小澜 ","choiceC": "ans 3", "choiceD":"ans 4"], "correct": 2]
        
        let answer4 = ["text": "问题4", "isImage": true, "tag": 111, "image": "close.png","choice": ["choiceA":"ans 1 abcdefb你好吗 小澜 ", "choiceB":"ans 2  ans 1 abcdefb你好吗 小澜 ","choiceC": "ans 3", "choiceD":"ans 4"], "correct": 3]
        let question1 = question.objectWithKeyValues(answer1)
        let question2 = question.objectWithKeyValues(answer2)
        let question3 = question.objectWithKeyValues(answer3)
        let question4 = question.objectWithKeyValues(answer4)
        
        questionSet.addObject(question1)
        questionSet.addObject(question2)
        questionSet.addObject(question3)
        questionSet.addObject(question4)
        */
        self.view.backgroundColor = UIColor.flatMidnightBlueColor()
        
        
        var beginToChat = UIButton(frame: CGRect(x: 10, y: 25, width: 30, height: 30))
        beginToChat.backgroundColor = UIColor.darkGrayColor()
        beginToChat.layer.cornerRadius = 25
        beginToChat.addTarget(self, action: "backToMain", forControlEvents: .TouchUpInside)
        self.view.addSubview(beginToChat)
        
        var cleanQuestion = UIButton(frame: CGRect(x: screenSize.width - 40, y: 25, width: 30, height: 30))
        cleanQuestion.backgroundColor = UIColor.darkGrayColor()
        cleanQuestion.layer.cornerRadius = 25
        cleanQuestion.addTarget(self, action: "resetData", forControlEvents: .TouchUpInside)
        self.view.addSubview(cleanQuestion)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 40, height: 40)
        overCollectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: 200), collectionViewLayout: layout)
        overCollectionView.dataSource = self
        overCollectionView.delegate = self
        overCollectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        overCollectionView.backgroundColor = UIColor.whiteColor()
        
        
        //self.view.addSubview(overView!)
        overView = UIView(frame: CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height))
        overView.layer.cornerRadius = 10.0
        var overViewTopButton = UIButton(frame: CGRect(x: 0, y: 10, width: screenSize.width, height: 30))
        overViewTopButton.backgroundColor = .whiteColor()
        overViewTopButton.layer.cornerRadius = 10.0
        let closeTriangle = UIImage(named: "close.png")
        overViewTopButton.contentMode = UIViewContentMode.ScaleAspectFit
        overViewTopButton.setImage(closeTriangle, forState: UIControlState.Normal)
        overViewTopButton.addTarget(self, action: "closeOverView", forControlEvents: .TouchUpInside)
        
        var overViewButton = UIButton(frame: CGRect(x: 10, y: screenSize.height - 40, width: 30, height: 30))
        overViewButton.backgroundColor = UIColor.blackColor()
        overViewButton.addTarget(self, action: "overViewQuestion", forControlEvents: .TouchUpInside)
        self.view.addSubview(overViewButton)
        
        overView.addSubview(overCollectionView)
        overView.addSubview(overViewTopButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        storyScrollView.reloadInputViews()
        totalQuestion = questionSet.count
        for i in questionSet{
            correctList[i["tag"] as! Int] = 0
        }
        
        questionCompleted = UILabel(frame: CGRect(x: 100, y: 25, width: screenSize.width - 200, height: 30))
        questionCompleted.text = "题目 " + toString(NSInteger(self.storyScrollView.contentOffset.x / storyScrollView.frame.width) + 1) + " of " + toString(totalQuestion)
        questionCompleted.textAlignment = NSTextAlignment.Center
        questionCompleted.textColor = UIColor.whiteColor()
        if screenSize.width <= 320 {
            questionCompleted.font = UIFont(name: "Helvetica Neue", size: 20)
        }else{
            questionCompleted.font = UIFont(name: "Helvetica Neue", size: 25)
        }
        self.view.addSubview(questionCompleted)
        
        if questionSet.count > 0{
            let q = questionSet[0] as! NSDictionary
            println(q)
            createCard(q["isImage"] as! Bool, text: q["text"] as! String, tag: q["tag"] as! Int,image: q["image"] as! String,page: 0)
            
            let q2 = questionSet[1] as! NSDictionary
            createCard(q2["isImage"] as! Bool, text: q2["text"] as! String, tag: q2["tag"] as! Int,image: q2["image"] as! String,page: 1)
            
        }
        
        // total number of correct questions
        totalCorrectView = UIButton(frame: CGRect(x: 100, y: screenSize.height - 40, width: screenSize.width - 200, height: 30))
        totalCorrect = UILabel(frame: CGRect(x: 5, y: 5, width: screenSize.width - 210, height: 20))
        totalCorrectView.backgroundColor = UIColor.flatCarrotColor()
        totalCorrectView.layer.cornerRadius = 5.0
        totalCorrect.layer.cornerRadius = 5.0
        totalCorrect.backgroundColor = UIColor.flatCarrotColor()
        totalCorrect.font = UIFont(name: "Helvetica Neue", size: 12)
        totalCorrect.textColor = UIColor.whiteColor()
        totalCorrect.textAlignment = NSTextAlignment.Center
        totalCorrect.text = "正确: " + toString(totalCorrectAns) + " of " + toString(totalQuestion)
        totalCorrectView.addTarget(self, action: "overViewQuestion", forControlEvents: .TouchUpInside)
        totalCorrectView.setTitle("", forState: UIControlState.Normal)
        totalCorrectView.addSubview(totalCorrect)
        
        self.view.addSubview(totalCorrectView)
        self.view.addSubview(storyScrollView)
        self.view.addSubview(overView)
    }
    
    func overViewQuestion(){
        
        let scale = JNWSpringAnimation(keyPath: "transform.translation.y")
        scale.damping = 100
        scale.mass = 10
        scale.fromValue = 0
        scale.toValue = -220
        overView.layer.addAnimation(scale, forKey: scale.keyPath)
        overView.transform = CGAffineTransformMakeTranslation(0, -220)
    }
    
    func closeOverView(){
        let scale = JNWSpringAnimation(keyPath: "transform.translation.y")
        scale.damping = 100
        scale.mass = 10
        scale.fromValue = -220
        scale.toValue = 0
        overView.layer.addAnimation(scale, forKey: scale.keyPath)
        overView.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    func loadData(){
        let entity = NSEntityDescription.entityForName("QuestionSelected", inManagedObjectContext: managedContext)
        //let questionS = QuestionSelected(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let tagFetch = NSFetchRequest(entityName: "QuestionSelected")
        tagFetch.predicate = NSPredicate(format: "tag != nil")
        var error: NSError?
        
        let results = managedContext.executeFetchRequest(tagFetch, error: &error) as! [QuestionSelected]
        println("this is results \(results.count)")
        for result in results {
            //managedContext.deleteObject(result)
        }
        
        if !managedContext.save(&error){
            println("Cannot Save Data \(error), \(error?.userInfo)")
        }
        
        if let file = NSBundle.mainBundle().pathForResource("Questions", ofType: "geojson") {
            let nsUrl = NSURL(fileURLWithPath: file)
            let data = NSData(contentsOfURL: nsUrl!)
            var json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: nil)
            let questions = json?.objectForKey("coordinates") as! NSArray
            if results.count == 0{
                for ques in questions{
                    let q = ques as! NSDictionary
                    //saveTag(questionX.tag)
                    questionSet.addObject(q)
                }
            }else{
                for ques in questions{
                    let q = ques as! NSDictionary
                    //if contains(results,item: questionX.tag){
                    questionSet.addObject(q)
                    //}
                }
            }
        }
    }
    
    func resetData(){
        let entity = NSEntityDescription.entityForName("QuestionSelected", inManagedObjectContext: managedContext)
        let question = QuestionSelected(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let tagFetch = NSFetchRequest(entityName: "QuestionSelected")
        tagFetch.predicate = NSPredicate(format: "tag != nil")
        var error: NSError?
        
        let results = managedContext.executeFetchRequest(tagFetch, error: &error) as! [QuestionSelected]
        for result in results {
            managedContext.deleteObject(result)
        }
        
        if !managedContext.save(&error){
            println("Cannot Save Data \(error), \(error?.userInfo)")
        }
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backToMain(){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func createCard(isImage: Bool,text: String,tag: Int, image: String,page: Int){
        let width = CGRectGetWidth(self.storyScrollView.frame)
        let height = CGRectGetHeight(self.storyScrollView.frame)
        let x = CGFloat(page) * width
        var cardView = CardView(frame: CGRect(x: x, y: 0, width: width, height: height))
        cardView.backgroundColor = cardViewColor
        
        var questionView = UITextView(frame: CGRect(x: 10, y: 10, width: width - 20, height: 100))
        questionView.text = text
        questionView.font = UIFont(name: "Helvetica Neue", size: 16)
        questionView.backgroundColor = cardViewColor
        questionView.editable = false
        questionView.selectable = false
        questionView.scrollEnabled = false
        questionView.sizeToFit()
        cardView.addSubview(questionView)
        
        
        var signImage = UIImageView(frame: CGRect(x: 10, y: 10 + questionView.frame.size.height, width: width - 20, height: 200 - questionView.frame.size.height))
        //signImage.sizeToFit()
        var img = UIImage(named: image)
        signImage.image = img
        signImage.contentMode = .ScaleAspectFit
        
        if isImage == true{
            cardView.addSubview(signImage)
        }
        
        let selectionViewY = signImage.frame.origin.y + signImage.frame.size.height
        var selectionView = UITableView(frame: CGRect(x: 0, y: selectionViewY + 10, width: width, height: height - selectionViewY))
        selectionView.separatorStyle = .None
        selectionView.layer.cornerRadius = 0.0
        selectionView.scrollEnabled = false
        selectionView.backgroundColor = cardViewColor
        selectionView.tag = tag
        selectionView.delegate = self
        selectionView.dataSource = self
        cardView.addSubview(selectionView)
        
        if isImage == false{
            selectionView.frame.origin.y = 25 + questionView.frame.size.height
        }
        
        cardView.frame.size.height = selectionView.frame.origin.y + selectionView.frame.size.height + 10
        
        self.storyScrollView.addSubview(cardView)
        if storyScrollView.contentSize.width <= x + width{
            self.storyScrollView.contentSize = CGSizeMake(x + width, height)
        }
        self.alreadyLoad.append(page)
        totalView++
    }
    
    func popOneOfArray(array: NSArray) -> String{
        let randomNum = arc4random_uniform(UInt32(array.count))
        let randomItem: AnyObject = array[NSInteger(randomNum)]
        return randomItem as! String
        
    }
    var totalView = 0
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.isKindOfClass(UIScrollView)) {
            let currentPage = storyScrollView.currentPage()
            let totalPage = NSInteger(storyScrollView.contentSize.width/storyScrollView.frame.size.width)
            questionCompleted.text = "题目 " + toString(currentPage + 1) + " of " + toString(totalQuestion)
            questionCompleted.font = UIFont(name: "Helvetica Neue", size: 16)
            println("\(storyScrollView.contentOffset.x)  \(storyScrollView.frame.size.width) \(storyScrollView.contentSize.width)")
            println(totalPage)
            if (storyScrollView.contentOffset.x + storyScrollView.frame.size.width > storyScrollView.contentSize.width) && (questionSet.count > totalPage){
                let q = questionSet[totalPage] as! NSDictionary
                createCard(q["isImage"] as! Bool, text: q["text"] as! String, tag: q["tag"] as! Int,image: q["image"] as! String,page:totalPage)
            }
            let lastPage = NSInteger(currentPage) - 1
            
            if lastPage > 0 && (storyScrollView.contentOffset.x < CGFloat(currentPage) * storyScrollView.frame.size.width){
                var samePage = 0
                for p in alreadyLoad{
                    if lastPage == p{
                        samePage++
                    }
                }
                if samePage == 0{
                    let q = questionSet[lastPage] as! NSDictionary
                    createCard(q["isImage"] as! Bool, text: q["text"] as! String, tag: q["tag"] as! Int,image: q["image"] as! String,page:lastPage)
                }
            }
            
            /*
            println("conditon1 \(storyScrollView.contentOffset.x < CGFloat(currentPage) * storyScrollView.frame.size.width)")
            println("condition2 \(totalPage) \(NSInteger(storyScrollView.contentSize.width / storyScrollView.frame.size.width))")
            
            
            if (storyScrollView.contentOffset.x < CGFloat(currentPage) * storyScrollView.frame.size.width) && (totalPage < NSInteger(storyScrollView.contentSize.width / storyScrollView.frame.size.width)) && (questionSet.count > totalPage){
            println("working")
            let q = questionSet[Int(currentPage) - 1] as! question
            createCard(q.isImage, text: q.text as! String, tag: q.tag,image: q.image! as String,page: Int(currentPage) - 2)
            println(Int(currentPage))
            
            }*/
            
            //self.storyScrollView.reloadInputViews()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.userInteractionEnabled = false
        let answer = selectedCell?.textLabel!.text
        for i in questionSet{
            let q = i as! NSDictionary
            if q["tag"] as! Int == tableView.tag{
                if q["correct"] as! Int == indexPath.row {
                    correctList[tableView.tag] = 1
                    selectedCell?.textLabel?.textColor = UIColor.flatGreenSeaColor()
                    totalCorrectAns += 1
                    totalCorrect.text = "正确: " + toString(totalCorrectAns) + " of " + toString(totalQuestion)
                    selectedCell?.imageView?.backgroundColor = UIColor.flatGreenSeaColor()
                }else{
                    correctList[tableView.tag] = 2
                    selectedCell?.textLabel?.textColor = UIColor.flatAlizarinColor()
                    selectedCell?.imageView?.backgroundColor = UIColor.flatAlizarinColor()
                    let indexP = NSIndexPath(forRow: q["correct"] as! Int, inSection: 0)
                    let otherCell = tableView.cellForRowAtIndexPath(indexP)
                    otherCell?.textLabel?.textColor = UIColor.flatGreenSeaColor()
                    otherCell?.imageView?.backgroundColor = UIColor.flatGreenSeaColor()
                }
            }
            
        }
        overCollectionView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "")
        for i in questionSet{
            let q = i as! NSDictionary
            if q["tag"] as! Int == tableView.tag{
                let ans = q["choice"] as! NSDictionary
                let choice = choiceName(Choice.objectWithKeyValues(ans),c:indexPath.row)
                cell.textLabel?.text = toString(choice)
                cell.textLabel?.sizeToFit()
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                if indexPath.row % 2 == 0{
                    cell.backgroundColor = UIColorFromRGB(0xf9f9f9)
                }
                
            }
        }
        cell.imageView?.backgroundColor = UIColor.flatSilverColor()
        cell.imageView?.image = UIImage(named: choiceSet[indexPath.row])
        cell.imageView?.contentMode = .ScaleAspectFit
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func choiceName(choices: Choice, c : Int) -> String{
        if c == 0{
            return choices.choiceA!
        }
        if(c == 1){
            return choices.choiceB!
        }
        if (c == 2){
            return choices.choiceC!
        }
        return choices.choiceD!
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionSet.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 10
        /*
        let smallLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        smallLabel.backgroundColor = UIColorFromRGB(0xe5e5e5)
        smallLabel.layer.cornerRadius = 10
        smallLabel.text = toString(indexPath.row + 1)
        smallLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(smallLabel)
        */
        let ans = correctList[questionSet[indexPath.row]["tag"] as! Int]
        if ans == 0{
            cell.textLabel.backgroundColor = UIColorFromRGB(0xe5e5e5)
        }else if (ans == 1){
            cell.textLabel.backgroundColor = UIColor.flatGreenSeaColor()
            cell.textLabel.textColor = UIColor.whiteColor()
        }else{
            cell.textLabel.backgroundColor = UIColor.flatAlizarinColor()
            cell.textLabel.textColor = UIColor.whiteColor()
        }
        cell.textLabel.layer.cornerRadius = 5.0
        cell.textLabel.text = toString(indexPath.row + 1)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        let q = questionSet[indexPath.row] as! NSDictionary
        createCard(q["isImage"] as! Bool, text: q["text"] as! String, tag: q["tag"] as! Int,image: q["image"] as! String,page: indexPath.row)
        storyScrollView.loadPageIndex(UInt(indexPath.row), animated: true)
    }
    
    
    func saveTag(tag: Int) {
        let entity = NSEntityDescription.entityForName("QuestionSelected", inManagedObjectContext: managedContext)
        let question = QuestionSelected(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        question.tag = tag
        
        var error: NSError?
        
        if !managedContext.save(&error) {
            println("Can not save data \(error), \(error?.userInfo)")
        }
    }
    
    func contains(array: [QuestionSelected], item: AnyObject) -> Bool{
        var count = 0
        for i in array{
            if i.tag.isEqual(item){
                count++
            }
        }
        return count > 0
    }
    
}

*/





/*

//
//  selfTestViewController.swift
//  G1
//
//  Created by Shawn on 2015-07-27.
//  Copyright (c) 2015 Shawn. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class selfTestViewController: UIViewController,UIActionSheetDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var managedContext: NSManagedObjectContext! = CoreDataStack().context
    var beginPage = 0
    let screenSize : CGRect = UIScreen.mainScreen().bounds
    var loading: KDCircularProgress!
    var storyScrollView : JT3DScrollView!
    var navigationBar : UINavigationBar!
    var questionCompleted : UILabel!
    var overView: UIView!
    var totalCorrectView : UIButton!
    var overCollectionView : UICollectionView!
    var cardViewColor = UIColor.whiteColor()
    var currentQuestion : Int = 1
    var totalQuestion : Int = 0
    var totalCorrectAns : Int = 0
    var totalCorrect : UILabel!
    var alreadyLoad = [Int]()
    var sampleData = NSDictionary()
    var correctList = [Int: Int]()
    var questionSet = NSMutableArray()
    var QuestionsSet = [NSManagedObject]()
    var choiceSet = ["a.png","b.png","c.png","d.png"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.storyScrollView = JT3DScrollView(frame: CGRect(x: 25, y: 80, width: screenSize.width - 50, height: screenSize.height - 150))
        self.storyScrollView.effect = JT3DScrollViewEffect.Carousel
        self.storyScrollView.delegate = self
        
        
        loading = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loading.startAngle = -90
        loading.progressThickness = 0.2
        loading.trackThickness = 0.6
        loading.clockwise = true
        loading.gradientRotateSpeed = 1
        loading.roundedCorners = false
        loading.glowMode = KDCircularProgressGlowMode.Forward
        loading.glowAmount = 0.9
        loading.setColors(UIColor.cyanColor() ,UIColor.whiteColor(), UIColor.magentaColor(), UIColor.whiteColor(), UIColor.orangeColor())
        loading.center = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(loading)
        
        
        loading.animateToAngle(360, duration: 1.5) { completed in
            if completed {
                self.loading.removeFromSuperview()
                self.view.addSubview(self.storyScrollView)
                self.view.addSubview(self.overView)
                let newPage = self.getPage()
                let q = self.questionSet[newPage] as! question
                self.createCard(q.isImage, text: q.text as! String, tag: q.tag,imageName: q.image! as String,page: newPage)
                self.storyScrollView.loadPageIndex(UInt(newPage), animated: false)
            } else {
                println("Error, Please reload")
            }
            
            let newPage = self.getPage()
            self.storyScrollView.loadPageIndex(UInt(newPage), animated: true)
        }
        /*
        let answer1 = ["text": "问题1", "isImage": false, "tag": 1, "image": "","choice": ["choiceA":"ans 1 abcdefb你好吗 小澜 ", "choiceB":"ans 2  ans 1 abcdefb你好吗 小澜 ","choiceC": "ans 3", "choiceD":"ans 4"], "correct": 2]
        
        let answer2 = ["text": "问题2", "isImage": true, "tag": 12, "image": "style.jpeg","choice": ["choiceA":"ans 1 abcdefb你好吗 小澜 ", "choiceB":"ans 2  ans 1 abcdefb你好吗 小澜 ","choiceC": "ans 3", "choiceD":"ans 4"], "correct": 1]
        
        let answer3 = ["text": "问题3", "isImage": false, "tag": 33, "image": "","choice": ["choiceA":"ans 1 abcdefb你好吗 小澜 ", "choiceB":"ans 2  ans 1 abcdefb你好吗 小澜 ","choiceC": "ans 3", "choiceD":"ans 4"], "correct": 2]
        
        let answer4 = ["text": "问题4", "isImage": true, "tag": 111, "image": "close.png","choice": ["choiceA":"ans 1 abcdefb你好吗 小澜 ", "choiceB":"ans 2  ans 1 abcdefb你好吗 小澜 ","choiceC": "ans 3", "choiceD":"ans 4"], "correct": 3]
        let question1 = question.objectWithKeyValues(answer1)
        let question2 = question.objectWithKeyValues(answer2)
        let question3 = question.objectWithKeyValues(answer3)
        let question4 = question.objectWithKeyValues(answer4)
        
        questionSet.addObject(question1)
        questionSet.addObject(question2)
        questionSet.addObject(question3)
        questionSet.addObject(question4)
        */
        self.view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        
        
        var beginToChat = UIButton(frame: CGRect(x: 10, y: 25, width: 30, height: 30))
        beginToChat.backgroundColor = UIColor.darkGrayColor()
        beginToChat.layer.cornerRadius = 25
        beginToChat.addTarget(self, action: "backToMain", forControlEvents: .TouchUpInside)
        self.view.addSubview(beginToChat)
        
        var cleanQuestion = UIButton(frame: CGRect(x: screenSize.width - 40, y: 25, width: 30, height: 30))
        cleanQuestion.backgroundColor = UIColor.darkGrayColor()
        cleanQuestion.layer.cornerRadius = 25
        cleanQuestion.addTarget(self, action: "resetData", forControlEvents: .TouchUpInside)
        self.view.addSubview(cleanQuestion)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 40, height: 40)
        overCollectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: 200), collectionViewLayout: layout)
        overCollectionView.dataSource = self
        overCollectionView.delegate = self
        overCollectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        overCollectionView.backgroundColor = UIColor.whiteColor()
        
        //self.view.addSubview(overView!)
        overView = UIView(frame: CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height))
        overView.layer.cornerRadius = 10.0
        var overViewTopButton = UIButton(frame: CGRect(x: 0, y: 10, width: screenSize.width, height: 30))
        overViewTopButton.backgroundColor = .whiteColor()
        overViewTopButton.layer.cornerRadius = 10.0
        let closeTriangle = UIImage(named: "close.png")
        overViewTopButton.contentMode = UIViewContentMode.ScaleAspectFit
        overViewTopButton.setImage(closeTriangle, forState: UIControlState.Normal)
        overViewTopButton.addTarget(self, action: "closeOverView", forControlEvents: .TouchUpInside)
        
        var overViewButton = UIButton(frame: CGRect(x: 10, y: screenSize.height - 40, width: 30, height: 30))
        overViewButton.backgroundColor = UIColor.blackColor()
        overViewButton.addTarget(self, action: "overViewQuestion", forControlEvents: .TouchUpInside)
        self.view.addSubview(overViewButton)
        
        overView.addSubview(overCollectionView)
        overView.addSubview(overViewTopButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        storyScrollView.reloadInputViews()
        totalQuestion = questionSet.count
        for i in questionSet{
            correctList[i.tag] = 0
        }
        if questionSet.count > 1{
            let q = questionSet[0] as! question
            createCard(q.isImage, text: q.text as! String, tag: q.tag,imageName: q.image! as String,page: 0)
            let q2 = questionSet[1] as! question
            createCard(q2.isImage, text: q2.text as! String, tag: q2.tag,imageName: q2.image! as String,page: 1)
        }
        
        questionCompleted = UILabel(frame: CGRect(x: 100, y: 25, width: screenSize.width - 200, height: 30))
        questionCompleted.text = "题目 " + toString(NSInteger(self.storyScrollView.contentOffset.x / storyScrollView.frame.width) + 1) + " of " + toString(totalQuestion)
        questionCompleted.textAlignment = NSTextAlignment.Center
        questionCompleted.textColor = UIColor.whiteColor()
        if screenSize.width <= 320 {
            questionCompleted.font = UIFont(name: "Helvetica Neue", size: 16)
        }else{
            questionCompleted.font = UIFont(name: "Helvetica Neue", size: 18)
        }
        self.view.addSubview(questionCompleted)
        
        // total number of correct questions
        totalCorrectView = UIButton(frame: CGRect(x: 100, y: screenSize.height - 40, width: screenSize.width - 200, height: 30))
        totalCorrect = UILabel(frame: CGRect(x: 5, y: 5, width: screenSize.width - 210, height: 18))
        totalCorrect.layer.cornerRadius = 5.0
        totalCorrect.font = UIFont(name: "Helvetica Neue", size: 12)
        totalCorrect.textColor = UIColor.whiteColor()
        totalCorrect.textAlignment = NSTextAlignment.Center
        totalCorrect.text = "正确: " + toString(totalCorrectAns) + " of " + toString(totalQuestion)
        totalCorrectView.backgroundColor = UIColor.flatGreenSeaColor()
        totalCorrectView.addTarget(self, action: "overViewQuestion", forControlEvents: .TouchUpInside)
        
        totalCorrectView.layer.cornerRadius = 5.0
        totalCorrectView.addSubview(totalCorrect)
        
        self.view.addSubview(totalCorrectView)
        
    }
    
    func overViewQuestion(){
        let scale = JNWSpringAnimation(keyPath: "transform.translation.y")
        scale.damping = 100
        scale.mass = 10
        scale.fromValue = 0
        scale.toValue = -220
        overView.layer.addAnimation(scale, forKey: scale.keyPath)
        overView.transform = CGAffineTransformMakeTranslation(0, -220)
    }
    
    func closeOverView(){
        let scale = JNWSpringAnimation(keyPath: "transform.translation.y")
        scale.damping = 100
        scale.mass = 10
        scale.fromValue = -220
        scale.toValue = 0
        overView.layer.addAnimation(scale, forKey: scale.keyPath)
        overView.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    func loadData(){
        
        let entity = NSEntityDescription.entityForName("QuestionSelected", inManagedObjectContext: managedContext)
        //let questionS = QuestionSelected(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let tagFetch = NSFetchRequest(entityName: "QuestionSelected")
        tagFetch.predicate = NSPredicate(format: "tag != nil")
        var error: NSError?
        
        let results = managedContext.executeFetchRequest(tagFetch, error: &error) as! [QuestionSelected]
        for result in results {
            //managedContext.deleteObject(result)
        }
        
        if !managedContext.save(&error){
            println("Cannot Save Data \(error), \(error?.userInfo)")
        }
        
        if let file = NSBundle.mainBundle().pathForResource("questions", ofType: "plist") {
            let dataDictionary = NSDictionary(contentsOfFile: file)
            println(dataDictionary)
            println("finished")
            
            /*
            let nsUrl = NSURL(fileURLWithPath: file)
            let data = NSData(contentsOfURL: nsUrl!)
            var json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: nil)
            let questions = json?.objectForKey("coordinates") as! NSArray
            if results.count == 0{
            for ques in questions{
            let q = ques as! NSDictionary
            let questionX = question.objectWithKeyValues(q)
            //saveTag(questionX.tag)
            questionSet.addObject(questionX)
            }
            }else{
            for ques in questions{
            let q = ques as! NSDictionary
            let questionX = question.objectWithKeyValues(q)
            //if contains(results,item: questionX.tag){
            questionSet.addObject(questionX)
            //}
            }
            }*/
        }
    }
    
    func resetData(){
        
        let entity = NSEntityDescription.entityForName("QuestionSelected", inManagedObjectContext: managedContext)
        let question = QuestionSelected(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let tagFetch = NSFetchRequest(entityName: "QuestionSelected")
        tagFetch.predicate = NSPredicate(format: "tag != nil")
        var error: NSError?
        
        let results = managedContext.executeFetchRequest(tagFetch, error: &error) as! [QuestionSelected]
        for result in results {
            managedContext.deleteObject(result)
        }
        
        if !managedContext.save(&error){
            println("Cannot Save Data \(error), \(error?.userInfo)")
        }
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backToMain(){
        self.storyScrollView.loadPageIndex(0, animated: false)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func createCard(isImage: Bool,text: String,tag: Int, imageName: String,page: Int){
        
        let width = CGRectGetWidth(self.storyScrollView.frame)
        let height = CGRectGetHeight(self.storyScrollView.frame)
        let x = CGFloat(page) * width
        var cardView = CardView(frame: CGRect(x: x, y: 0, width: width, height: height))
        cardView.backgroundColor = cardViewColor
        
        var questionView = UITextView(frame: CGRect(x: 10, y: 10, width: width - 20, height: 100))
        questionView.text = text
        questionView.font = UIFont(name: "Helvetica Neue", size: 16)
        questionView.backgroundColor = cardViewColor
        questionView.editable = false
        questionView.selectable = false
        questionView.scrollEnabled = false
        questionView.sizeToFit()
        cardView.addSubview(questionView)
        
        var signImage = UIImageView(frame: CGRect(x: 10, y: 10 + questionView.frame.size.height, width: width - 20, height: 200 - questionView.frame.size.height))
        if isImage == true{
            //signImage.sizeToFit()
            let img = UIImage(named: imageName)
            signImage.image = img
            signImage.contentMode = .ScaleAspectFit
            cardView.addSubview(signImage)
        }
        
        let selectionViewY = signImage.frame.origin.y + signImage.frame.size.height
        var selectionView = UITableView(frame: CGRect(x: 0, y: selectionViewY + 10, width: width, height: 160))
        selectionView.separatorStyle = .None
        selectionView.layer.cornerRadius = 0.0
        selectionView.scrollEnabled = false
        selectionView.backgroundColor = cardViewColor
        selectionView.tag = tag
        selectionView.delegate = self
        selectionView.dataSource = self
        cardView.addSubview(selectionView)
        if isImage == false{
            selectionView.frame.origin.y = 25 + questionView.frame.size.height
        }
        
        cardView.frame.size.height = selectionView.frame.origin.y + selectionView.frame.size.height + 10
        self.storyScrollView.addSubview(cardView)
        if storyScrollView.contentSize.width <= x + width{
            self.storyScrollView.contentSize = CGSizeMake(x + width, height)
        }
        self.alreadyLoad.append(page)
        totalView++
    }
    
    func popOneOfArray(array: NSArray) -> String{
        let randomNum = arc4random_uniform(UInt32(array.count))
        let randomItem: AnyObject = array[NSInteger(randomNum)]
        return randomItem as! String
        
    }
    var totalView = 0
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.isKindOfClass(UIScrollView)) {
            let currentPage = storyScrollView.currentPage()
            if currentPage != 0 {
                savePage(NSInteger(currentPage))
            }
            println("getpage \(getPage())")
            
            let totalPage = NSInteger(storyScrollView.contentSize.width/storyScrollView.frame.size.width)
            questionCompleted.text = "题目 " + toString(currentPage + 1) + " of " + toString(totalQuestion)
            questionCompleted.font = UIFont(name: "Helvetica Neue", size: 16)
            //println("\(storyScrollView.contentOffset.x)  \(storyScrollView.frame.size.width) \(storyScrollView.contentSize.width)")
            if (storyScrollView.contentOffset.x + storyScrollView.frame.size.width > storyScrollView.contentSize.width) && (questionSet.count > totalPage){
                let q = questionSet[totalPage] as! question
                createCard(q.isImage, text: q.text as! String, tag: q.tag,imageName: q.image! as String,page:totalPage)
            }
            let lastPage = NSInteger(currentPage) - 1
            
            if lastPage > 0 && (storyScrollView.contentOffset.x < CGFloat(currentPage) * storyScrollView.frame.size.width){
                var samePage = 0
                for p in alreadyLoad{
                    if lastPage == p{
                        samePage++
                    }
                }
                if samePage == 0{
                    let q = questionSet[lastPage] as! question
                    createCard(q.isImage, text: q.text as! String, tag: q.tag,imageName: q.image! as String,page:lastPage)
                }
            }
            
            /*
            println("conditon1 \(storyScrollView.contentOffset.x < CGFloat(currentPage) * storyScrollView.frame.size.width)")
            println("condition2 \(totalPage) \(NSInteger(storyScrollView.contentSize.width / storyScrollView.frame.size.width))")
            
            
            if (storyScrollView.contentOffset.x < CGFloat(currentPage) * storyScrollView.frame.size.width) && (totalPage < NSInteger(storyScrollView.contentSize.width / storyScrollView.frame.size.width)) && (questionSet.count > totalPage){
            println("working")
            let q = questionSet[Int(currentPage) - 1] as! question
            createCard(q.isImage, text: q.text as! String, tag: q.tag,image: q.image! as String,page: Int(currentPage) - 2)
            println(Int(currentPage))
            
            }*/
            
            //self.storyScrollView.reloadInputViews()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.userInteractionEnabled = false
        let answer = selectedCell?.textLabel!.text
        for i in questionSet{
            let q = i as! question
            if q.tag == tableView.tag{
                if q.correct == indexPath.row {
                    correctList[tableView.tag] = 1
                    selectedCell?.textLabel?.textColor = UIColor.flatGreenSeaColor()
                    totalCorrectAns += 1
                    totalCorrect.text = "正确: " + toString(totalCorrectAns) + " of " + toString(totalQuestion)
                    selectedCell?.imageView?.backgroundColor = UIColor.flatGreenSeaColor()
                }else{
                    correctList[tableView.tag] = 2
                    selectedCell?.textLabel?.textColor = UIColor.flatAlizarinColor()
                    selectedCell?.imageView?.backgroundColor = UIColor.flatAlizarinColor()
                    let indexP = NSIndexPath(forRow: q.correct, inSection: 0)
                    let otherCell = tableView.cellForRowAtIndexPath(indexP)
                    otherCell?.textLabel?.textColor = UIColor.flatGreenSeaColor()
                    otherCell?.imageView?.backgroundColor = UIColor.flatGreenSeaColor()
                }
            }
            
        }
        overCollectionView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "")
        for i in questionSet{
            let q = i as! question
            if q.tag == tableView.tag{
                let ans = q.choice
                let choice = choiceName(ans,c:indexPath.row)
                cell.textLabel?.text = toString(choice)
                cell.textLabel?.sizeToFit()
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                if indexPath.row % 2 == 0{
                    cell.backgroundColor = UIColorFromRGB(0xf9f9f9)
                }
                
            }
        }
        cell.imageView?.backgroundColor = UIColor.flatSilverColor()
        cell.imageView?.image = UIImage(named: choiceSet[indexPath.row])
        cell.imageView?.contentMode = .ScaleAspectFit
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func choiceName(choices: Choice, c : Int) -> String{
        if c == 0{
            return choices.choiceA!
        }
        if(c == 1){
            return choices.choiceB!
        }
        if (c == 2){
            return choices.choiceC!
        }
        return choices.choiceD!
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionSet.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 10
        /*
        let smallLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        smallLabel.backgroundColor = UIColorFromRGB(0xe5e5e5)
        smallLabel.layer.cornerRadius = 10
        smallLabel.text = toString(indexPath.row + 1)
        smallLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(smallLabel)
        */
        let ans = correctList[questionSet[indexPath.row].tag]
        if ans == 0{
            cell.textLabel.backgroundColor = UIColorFromRGB(0xe5e5e5)
        }else if (ans == 1){
            cell.textLabel.backgroundColor = UIColor.flatGreenSeaColor()
            cell.textLabel.textColor = UIColor.whiteColor()
        }else{
            cell.textLabel.backgroundColor = UIColor.flatAlizarinColor()
            cell.textLabel.textColor = UIColor.whiteColor()
        }
        cell.textLabel.layer.cornerRadius = 5.0
        cell.textLabel.text = toString(indexPath.row + 1)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        let q = questionSet[indexPath.row] as! question
        createCard(q.isImage, text: q.text as! String, tag: q.tag,imageName: q.image! as String,page: indexPath.row)
        storyScrollView.loadPageIndex(UInt(indexPath.row), animated: true)
    }
    
    
    func saveTag(tag: Int) {
        let entity = NSEntityDescription.entityForName("QuestionSelected", inManagedObjectContext: managedContext)
        let question = QuestionSelected(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        question.tag = tag
        
        var error: NSError?
        
        if !managedContext.save(&error) {
            println("Can not save data \(error), \(error?.userInfo)")
        }
    }
    
    func savePage(page: Int){
        let pageSave = NSUserDefaults.standardUserDefaults()
        pageSave.setInteger(page, forKey: "regularPage")
    }
    
    func getPage() -> Int{
        let pageLoad = NSUserDefaults.standardUserDefaults()
        let newPage = pageLoad.integerForKey("regularPage")
        return newPage
    }
    
    func contains(array: [QuestionSelected], item: AnyObject) -> Bool{
        var count = 0
        for i in array{
            if i.tag.isEqual(item){
                count++
            }
        }
        return count > 0
    }
    
}*/

