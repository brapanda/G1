//
//  examViewController.swift
//  G1
//
//  Created by Shawn on 2015-07-27.
//  Copyright (c) 2015 Shawn. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class examViewController: UIViewController,UIActionSheetDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate {
    var managedContext: NSManagedObjectContext! = ECoreData().context
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
    let UserData = NSUserDefaults.standardUserDefaults()
    var totalQuestion : Int = 0
    var totalCorrectAns : Int = 0
    var totalCorrect : UILabel!
    var alreadyLoad = [Int]()
    var sampleData = NSDictionary()
    var selectedList = [String: Int]()
    var pageList = [String: Int]()
    var questionSet = NSMutableArray()
    var QuestionsSet = [NSManagedObject]()
    var qset = NSMutableArray()
    var choiceSet = ["a.png","b.png","c.png","d.png"]
    var fontSize : CGFloat = 16
    var choicesList = ["choiceA", "choiceB", "choiceC", "choiceD"]
    var correctColor = UIColorFromRGB(0x8BC34A)
    var wrongColor = UIColorFromRGB(0xF44336)
    var correctImage = UIImage(named: "correct.png")
    var wrongImage = UIImage(named: "wrong.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.storyScrollView = JT3DScrollView(frame: CGRect(x: 25, y: 80, width: screenSize.width - 50, height: screenSize.height - 150))
        self.storyScrollView.effect = JT3DScrollViewEffect.Carousel
        self.storyScrollView.delegate = self
        
        if let selections: AnyObject = UserData.valueForKey("selectedList_exam"){
            selectedList = selections as! NSDictionary as! [String: Int]
        }else{
            UserData.setValue(selectedList, forKey: "selectedList_exam")
        }
        if let pages: AnyObject = UserData.valueForKey("pageList_exam") {
            pageList = pages as! NSDictionary as! [String: Int]
        }else{
            UserData.setValue(pageList, forKey: "pageList_exam")
        }
        totalCorrectAns = UserData.integerForKey("totalCorrectAns_exam") as NSInteger
        
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
        loading.center = CGPoint(x: view.center.x, y: view.center.y*0.8)
        
        let loadBool = UserData.boolForKey("loadData_exam")
        if loadBool == false{
            view.addSubview(loading)
            loading.animateToAngle(360, duration: 1.5) { completed in
                if completed {
                    self.loading.removeFromSuperview()
                    self.view.addSubview(self.storyScrollView)
                    self.view.addSubview(self.overView)
                } else {
                    println("Error, Please reload")
                }
                
                let newPage = self.getPage()
                if newPage < self.QuestionsSet.count{
                    self.createCard(self.QuestionsSet[newPage] as! EQuestion, page: newPage)
                    self.storyScrollView.loadPageIndex(UInt(newPage), animated: false)
                }else{
                    self.storyScrollView.loadPageIndex(0, animated: false)
                }
                
            }
        }
        self.view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        
        
        var backButton = UIButton(frame: CGRect(x: 10, y: 25, width: 30, height: 30))
        backButton.setImage(UIImage(named: "backButton.png"), forState: UIControlState.Normal)
        backButton.layer.cornerRadius = 25
        backButton.addTarget(self, action: "backToMain", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        var cleanQuestion = UIButton(frame: CGRect(x: screenSize.width - 70, y: 25, width: 60, height: 30))
        cleanQuestion.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        cleanQuestion.setTitle("重新开始", forState: UIControlState.Normal)
        cleanQuestion.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cleanQuestion.backgroundColor = UIColor.blackColor()
        cleanQuestion.alpha = 0.5
        cleanQuestion.layer.cornerRadius = 3
        cleanQuestion.addTarget(self, action: "alertReset", forControlEvents: .TouchUpInside)
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
        let triangleView = UIImageView(frame: CGRect(x: screenSize.width * 0.5 - 15, y: 0, width: 30, height: 30))
        let closeTriangle = UIImage(named: "closeView.png")
        triangleView.image = closeTriangle
        overViewTopButton.contentMode = UIViewContentMode.ScaleAspectFit
        overViewTopButton.addSubview(triangleView)
        //overViewTopButton.setImage(closeTriangle, forState: UIControlState.Normal)
        overViewTopButton.addTarget(self, action: "closeOverView", forControlEvents: .TouchUpInside)
        
        var swipeDown = UISwipeGestureRecognizer(target:self, action:Selector("swipe:"))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        overViewTopButton.addGestureRecognizer(swipeDown)
        
        overView.addSubview(overCollectionView)
        overView.addSubview(overViewTopButton)
        
    }
    
    func swipe(recognizer: UISwipeGestureRecognizer){
        if recognizer.direction == UISwipeGestureRecognizerDirection.Down{
            closeOverView()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let loadBool = UserData.boolForKey("loadData_exam")
        if loadBool == false{
            loadData()
            setData()
            UserData.setBool(true, forKey: "loadData_exam")
        }else{
            setData()
        }
        
        
        storyScrollView.reloadInputViews()
        totalQuestion = QuestionsSet.count
        
        if QuestionsSet.count > 1{
            let q = QuestionsSet[0] as! EQuestion
            createCard(q,page: 0)
            let q2 = QuestionsSet[1] as! EQuestion
            createCard(q2,page: 1)
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
        totalCorrectView.backgroundColor = correctColor
        totalCorrectView.addTarget(self, action: "overViewQuestion", forControlEvents: .TouchUpInside)
        
        totalCorrectView.layer.cornerRadius = 5.0
        totalCorrectView.addSubview(totalCorrect)
        
        self.view.addSubview(totalCorrectView)
        let loadBools = UserData.boolForKey("loadData_exam")
        if loadBools == true{
            self.loading.removeFromSuperview()
            self.view.addSubview(self.storyScrollView)
            self.view.addSubview(self.overView)
            let goPage = self.getPage()
            if goPage < self.QuestionsSet.count{
                self.createCard(self.QuestionsSet[goPage] as! EQuestion, page: goPage)
                self.storyScrollView.loadPageIndex(UInt(goPage), animated: false)
            }else{
                self.storyScrollView.loadPageIndex(0, animated: false)
            }
        }
        
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
        
        let questionFetch = NSFetchRequest(entityName: "EQuestion")
        questionFetch.predicate = NSPredicate(format: "tag != 0")
        let count = managedContext.countForFetchRequest(questionFetch, error: nil)
        
        if count > 0 {
            return
        }
        
        let file = NSBundle.mainBundle().pathForResource("questions", ofType: "plist")
        let dataDictionary = NSDictionary(contentsOfFile: file!)
        var keysList = dataDictionary!.allKeys as! [String]
        var keysSign = [String]()
        var keysText = [String]()
        for (key,value) in dataDictionary!{
            let ques = value as! NSDictionary
            if ques["sign"] as! Bool == true{
                keysSign.append(key as! String)
            }
        }
        for (key,value) in dataDictionary!{
            let ques = value as! NSDictionary
            if ques["sign"] as! Bool == false{
                keysText.append(key as! String)
            }
        }
        for i in 1...20 {
            let entity = NSEntityDescription.entityForName("EQuestion", inManagedObjectContext: managedContext)
            let ques = EQuestion(entity: entity!, insertIntoManagedObjectContext: managedContext)
            let randomNum = arc4random_uniform(UInt32(keysSign.count))
            let key = keysSign[Int(randomNum)] as! String
            let q = dataDictionary?.valueForKey(key) as! NSDictionary
            
            ques.tag = q["tag"] as! Int
            ques.text = q["text"] as! String
            ques.isImage = q["isImage"] as! Bool
            ques.selected = q["selected"] as! NSNumber
            
            if q["isImage"] as! Bool == true{
                let img = UIImage(named: q["image"] as! String)
                let imageData = UIImagePNGRepresentation(img)
                ques.image = imageData
            }
            let regularChoice = q["choice"] as! NSDictionary
            let newChoice = randomChoice(regularChoice)
            let correctAns = q["correct"] as! Int
            let choiceNum = choicesList[correctAns]
            let correctChoice = regularChoice[choiceNum] as! String
            ques.choice = newChoice
            for c in 0...3{
                if correctChoice == newChoice[c] as! String {
                    ques.correct = c
                }
            }
            
            var error: NSError?
            if !managedContext.save(&error){
                println("Cannot save data \(error), \(error?.userInfo)")
            }
            keysSign.removeAtIndex(Int(randomNum))
        }
        for i in 1...20 {
            let entity = NSEntityDescription.entityForName("EQuestion", inManagedObjectContext: managedContext)
            let ques = EQuestion(entity: entity!, insertIntoManagedObjectContext: managedContext)
            let randomNum = arc4random_uniform(UInt32(keysText.count))
            let key = keysText[Int(randomNum)] as! String
            let q = dataDictionary?.valueForKey(key) as! NSDictionary
            
            ques.tag = q["tag"] as! Int
            ques.text = q["text"] as! String
            ques.isImage = q["isImage"] as! Bool
            ques.selected = q["selected"] as! NSNumber
            
            if q["isImage"] as! Bool == true{
                let img = UIImage(named: q["image"] as! String)
                let imageData = UIImagePNGRepresentation(img)
                ques.image = imageData
            }
            let regularChoice = q["choice"] as! NSDictionary
            let newChoice = randomChoice(regularChoice)
            let correctAns = q["correct"] as! Int
            let choiceNum = choicesList[correctAns]
            let correctChoice = regularChoice[choiceNum] as! String
            ques.choice = newChoice
            for c in 0...3{
                if correctChoice == newChoice[c] as! String {
                    ques.correct = c
                }
            }
            
            var error: NSError?
            if !managedContext.save(&error){
                println("Cannot save data \(error), \(error?.userInfo)")
            }
            keysText.removeAtIndex(Int(randomNum))
        }
        
    }
    
    func randomChoice(ans: NSDictionary) -> NSArray{
        var newChoice = [String]()
        var keys = ans.allKeys as! [String]
        var choiceList = ["choiceA","choiceB","choiceC","choiceD"]
        for i in 0...3{
            let randomNum = arc4random_uniform(UInt32(keys.count))
            let random = keys[Int(randomNum)] as! String
            newChoice.append(ans[random] as! String)
            keys.removeAtIndex(Int(randomNum))
        }
        return newChoice
    }
    
    func setData(){
        
        let entity = NSEntityDescription.entityForName("EQuestion", inManagedObjectContext: managedContext)
        let question = EQuestion(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let tagFetch = NSFetchRequest(entityName: "EQuestion")
        tagFetch.predicate = NSPredicate(format: "tag != 0")
        var error: NSError?
        
        let results = managedContext.executeFetchRequest(tagFetch, error: &error) as! [EQuestion]
        let loadBool = UserData.boolForKey("loadData_exam")
        if loadBool == false{
            for result in results {
                let ques = result as! EQuestion
                selectedList[toString(ques.tag)] = Int(ques.selected)
                //managedContext.deleteObject(result)
            }
        }
        UserData.setValue(selectedList, forKey: "selectedList_exam")
        
        QuestionsSet = results
        for q in QuestionsSet{
            let p = q as! EQuestion
        }
        if !managedContext.save(&error){
            println("Cannot Save Data \(error), \(error?.userInfo)")
        }
    }
    
    func resetData(){
        let entity = NSEntityDescription.entityForName("EQuestion", inManagedObjectContext: managedContext)
        let question = EQuestion(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let tagFetch = NSFetchRequest(entityName: "EQuestion")
        tagFetch.predicate = NSPredicate(format: "tag != 0")
        var error: NSError?
        
        let results = managedContext.executeFetchRequest(tagFetch, error: &error) as! [EQuestion]
        let loadBool = UserData.boolForKey("loadData_exam")
        for result in results {
            managedContext.deleteObject(result)
        }
        UserData.setValue([String: Int](), forKey: "selectedList_exam")
        UserData.setBool(false, forKey: "loadData_exam")
        
        if !managedContext.save(&error){
            println("Cannot Save Data \(error), \(error?.userInfo)")
        }
        
        UserData.setBool(false, forKey: "loadData_exam")
        loadData()
        setData()
        for q in QuestionsSet{
            let ques = q as! EQuestion
        }
        UserData.setBool(true, forKey: "loadData_exam")
        totalQuestion = QuestionsSet.count
        selectedList = [String: Int]()
        pageList = [String: Int]()
        UserData.setValue(selectedList, forKey: "selectedList_exam")
        UserData.setValue(pageList, forKey: "pageList_exam")
        UserData.setInteger(0, forKey: "totalCorrectAns_exam")
        totalCorrectAns = 0
        totalCorrect.text = "正确: " + toString(totalCorrectAns) + " of " + toString(totalQuestion)
        
        for cardView in storyScrollView.subviews{
            cardView.removeFromSuperview()
        }
        self.alreadyLoad = [Int]()
        storyScrollView.contentSize = CGSizeMake(storyScrollView.frame.size.width, storyScrollView.frame.size.height)
        if QuestionsSet.count > 1{
            let q = QuestionsSet[0] as! EQuestion
            createCard(q,page: 0)
            let q2 = QuestionsSet[1] as! EQuestion
            createCard(q2,page: 1)
        }
        storyScrollView.loadPageIndex(0, animated: true)
        storyScrollView.reloadInputViews()
        overCollectionView.reloadData()
        
    }
    
    func alertReset(){
        if objc_getClass("UIAlertController") != nil{
            let alert : UIAlertController = UIAlertController(title: "确定要重新开始测试吗?", message: "重新测试会导致现有分数和题目消失", preferredStyle: UIAlertControllerStyle.Alert)
            let confirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { action in
                self.resetData()
            })
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(confirm)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "确定要重新开始测试吗?"
            alert.message = "重新测试会导致现有分数和题目消失"
            alert.delegate = self
            
            alert.addButtonWithTitle("确定")
            alert.addButtonWithTitle("取消")
            alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            resetData()
        case 1:
            println("cancel")
        default:
            println("default")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backToMain(){
        UserData.setValue(totalCorrectAns, forKey: "totalCorrectAns_exam")
        let currectPage = storyScrollView.currentPage()
        savePage(NSInteger(currectPage))
        self.storyScrollView.loadPageIndex(0, animated: false)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func createCard(questionData: EQuestion,page: Int){
        
        let width = CGRectGetWidth(self.storyScrollView.frame)
        let height = CGRectGetHeight(self.storyScrollView.frame)
        let x = CGFloat(page) * width
        var cardView = CardView(frame: CGRect(x: x, y: 0, width: width, height: height))
        
        cardView.backgroundColor = cardViewColor
        
        var questionView = UITextView(frame: CGRect(x: 10, y: 10, width: width - 20, height: 100))
        questionView.text = questionData.text
        questionView.font = UIFont(name: "Helvetica Neue", size: 16)
        questionView.backgroundColor = cardViewColor
        questionView.editable = false
        questionView.selectable = false
        questionView.scrollEnabled = false
        questionView.sizeToFit()
        cardView.addSubview(questionView)
        
        var signImage = UIImageView(frame: CGRect(x: 10, y: 10 + questionView.frame.size.height, width: width - 20, height: 200 - questionView.frame.size.height))
        if questionData.isImage == true{
            let img = UIImage(data: questionData.image)
            signImage.image = img
            signImage.contentMode = .ScaleAspectFit
            cardView.addSubview(signImage)
        }
        
        let selections = questionData.choice as! NSArray
        var totalHeight : CGFloat = 0
        for textValue in selections{
            let cText = textValue as! String
            totalHeight += sizeForString(cText)
        }
        let selectionViewY = signImage.frame.origin.y + signImage.frame.size.height
        var selectionView = UITableView(frame: CGRect(x: 0, y: selectionViewY + 10, width: width, height: totalHeight))
        selectionView.separatorStyle = .None
        selectionView.layer.cornerRadius = 0.0
        selectionView.scrollEnabled = false
        selectionView.backgroundColor = cardViewColor
        selectionView.tag = questionData.tag as! Int
        selectionView.delegate = self
        selectionView.dataSource = self
        cardView.addSubview(selectionView)
        if questionData.isImage == false{
            selectionView.frame.origin.y = 25 + questionView.frame.size.height
        }
        
        cardView.frame.size.height = selectionView.frame.origin.y + selectionView.frame.size.height + 10
        self.storyScrollView.addSubview(cardView)
        if storyScrollView.contentSize.width <= x + width{
            self.storyScrollView.contentSize = CGSizeMake(x + width, height)
        }
        self.alreadyLoad.append(page)
        
        pageList[toString(page)] = Int(questionData.tag)
        UserData.setValue(pageList, forKey: "pageList_exam")
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
            let totalPage = NSInteger(currentPage + 1)
            questionCompleted.text = "题目 " + toString(currentPage + 1) + " of " + toString(totalQuestion)
            //println("\(storyScrollView.contentOffset.x)  \(storyScrollView.frame.size.width) \(storyScrollView.contentSize.width)")
            if (storyScrollView.contentOffset.x > storyScrollView.frame.size.width * CGFloat(currentPage)) && (QuestionsSet.count > totalPage){
                let q = QuestionsSet[totalPage] as! EQuestion
                if !contains(alreadyLoad,totalPage){
                    
                    createCard(q,page:totalPage)
                }
                
            }
            let lastPage = NSInteger(currentPage) - 1
            
            if lastPage > 0 && (storyScrollView.contentOffset.x < CGFloat(currentPage) * storyScrollView.frame.size.width){
                if !contains(alreadyLoad,lastPage){
                    let q = QuestionsSet[lastPage] as! EQuestion
                    createCard(q,page:lastPage)
                    
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.userInteractionEnabled = false
        let answer = selectedCell?.textLabel!.text
        for i in QuestionsSet{
            let q = i as! EQuestion
            if q.tag == tableView.tag{
                selectedList[toString(tableView.tag)] = indexPath.row
                UserData.setValue(selectedList, forKey: "selectedList_exam")
                let saveData = UserData.valueForKey("selectedList_exam")
                if q.correct == indexPath.row {
                    selectedCell?.textLabel?.textColor = correctColor
                    totalCorrectAns += 1
                    totalCorrect.text = "正确: " + toString(totalCorrectAns) + " of " + toString(totalQuestion)
                    selectedCell?.imageView?.image = correctImage
                    UserData.setInteger(totalCorrectAns, forKey: "totalCorrectAns_exam")
                }else{
                    selectedCell?.textLabel?.textColor = wrongColor
                    selectedCell?.imageView?.image = wrongImage
                    let indexP = NSIndexPath(forRow: Int(q.correct), inSection: 0)
                    let otherCell = tableView.cellForRowAtIndexPath(indexP)
                    otherCell?.textLabel?.textColor = correctColor
                    otherCell?.imageView?.image = correctImage
                }
            }
            
        }
        overCollectionView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "")
        
        cell.imageView?.image = UIImage(named: choiceSet[indexPath.row])
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        for i in QuestionsSet{
            let q = i as! EQuestion
            if q.tag == tableView.tag{
                let ans = q.choice as! NSArray
                let choice = ans[indexPath.row]
                cell.textLabel?.text = toString(choice)
                cell.textLabel?.sizeToFit()
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                if indexPath.row % 2 == 0{
                    cell.backgroundColor = UIColorFromRGB(0xf9f9f9)
                }
                
                let selectedAns = selectedList[toString(q.tag)]
                if selectedAns != 4 && selectedAns != nil{
                    tableView.userInteractionEnabled = false
                    if q.correct == indexPath.row {
                        cell.textLabel?.textColor = correctColor
                        cell.imageView?.image = correctImage
                    }
                    if selectedAns == indexPath.row && q.correct != indexPath.row{
                        cell.textLabel?.textColor = wrongColor
                        cell.imageView?.image = wrongImage
                        let indexP = NSIndexPath(forRow: Int(q.correct), inSection: 0)
                        let otherCell = tableView.cellForRowAtIndexPath(indexP)
                        otherCell?.textLabel?.textColor = correctColor
                        otherCell?.imageView?.image = correctImage
                        otherCell?.imageView?.contentMode = .ScaleAspectFit
                    }
                    
                }
            }
        }
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    func sizeForString(text: String) -> CGFloat{
        let screenWidth = screenSize.width
        if screenWidth <= 325 {
            let numOfWord = CGFloat(count(text))
            return ceil(numOfWord / 11) * 20 + 15
        }
        
        if screenWidth <= 380{
            let numOfWord = CGFloat(count(text))
            return ceil(numOfWord / 15) * 20 + 15
        }
        
        let numOfWord = CGFloat(count(text))
        return ceil(numOfWord / 16) * 20 + 15
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height : CGFloat = 40
        for i in QuestionsSet{
            let q = i as! EQuestion
            if q.tag == tableView.tag{
                let ans = q.choice as! NSArray
                let choice = ans[indexPath.row] as! String
                height = sizeForString(choice)
            }
        }
        
        
        return height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QuestionsSet.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 10
        
        cell.textLabel.textColor = UIColor.blackColor()
        cell.textLabel.backgroundColor = UIColorFromRGB(0xe5e5e5)
        if let tag = pageList[toString(indexPath.row)] {
            let q = QuestionsSet[indexPath.row] as! EQuestion
            if let ans = selectedList[toString(tag)] {
                if (ans == q.correct){
                    cell.textLabel.backgroundColor = correctColor
                    cell.textLabel.textColor = UIColor.whiteColor()
                }else{
                    if ans != 4{
                        cell.textLabel.backgroundColor = wrongColor
                        cell.textLabel.textColor = UIColor.whiteColor()
                    }
                }
            }
        }
        cell.textLabel.layer.cornerRadius = 5.0
        cell.textLabel.text = toString(indexPath.row + 1)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        let q = QuestionsSet[indexPath.row] as! EQuestion
        if !contains(alreadyLoad, indexPath.row){
            
            createCard(q,page:indexPath.row)
        }
        storyScrollView.loadPageIndex(UInt(indexPath.row), animated: true)
    }
    
    func savePage(page: Int){
        UserData.setInteger(page, forKey: "regularPage_exam")
    }
    
    func getPage() -> Int{
        let newPage = UserData.integerForKey("regularPage_exam")
        return newPage
    }
}
