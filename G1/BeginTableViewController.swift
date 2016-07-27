//
//  BeginTableViewController.swift
//
//
//  Created by Shawn on 2015-07-25.
//
//

import UIKit

class BeginTableViewController: UITableViewController {
    var screenSize : CGRect = UIScreen.mainScreen().bounds
    //let fontList = UIFont.familyNames()
    var headerView: ParallaxHeaderView!
    var cellView : UIView!
    var icon : UIImageView!
    var text : UILabel!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        //self.navigationController?.navigationBar.frame = CGRectMake(0, 0, 0, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        headerView = ParallaxHeaderView.parallaxHeaderViewWithCGSize(CGSizeMake(self.tableView.frame.size.height, 300)) as! ParallaxHeaderView
        self.tableView.backgroundColor = UIColor(white: 0.22, alpha: 1)
        headerView.headerImage = UIImage(named: "coverImage.jpg")
        headerView.headerTitleLabel.text = "G1 备考"
        headerView.headerTitleLabel.font = fontSize(70)
        self.tableView.tableHeaderView = headerView
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "")
        cell.backgroundColor = UIColor(white: 0.22, alpha: 1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cellView = UIView(frame: CGRect(x: 10, y: 10, width: screenSize.width - 20, height: 60))
        icon = UIImageView(frame: CGRect(x: 10, y: 10, width: cellView.frame.height - 20, height: cellView.frame.height - 20))
        text = UILabel(frame: CGRect(x: cellView.frame.height + 20, y: 10, width: cellView.frame.width - cellView.frame.height - 30, height: cellView.frame.height - 20))
        cellView.addSubview(icon)
        cellView.addSubview(text)
        cellView.layer.cornerRadius = 5.0
        cellView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cellView.layer.shadowOpacity = 0.8
        if indexPath.row == 0{
            icon.image = UIImage(named: "icon1.png")
            text.text = "顺序测试"
            text.font = fontSize(20)
            text.textColor = .blackColor()
            cellView.backgroundColor = UIColorFromRGB(0x388298)
        }
        if indexPath.row == 1{
            icon.image = UIImage(named: "icon2.png")
            text.text = "随机测试"
            text.font = fontSize(20)
            text.textColor = .blackColor()
            cellView.backgroundColor = UIColorFromRGB(0x299982)
        }
        if indexPath.row == 2{
            icon.image = UIImage(named: "icon3.png")
            text.text = "模拟考试"
            text.font = fontSize(20)
            text.textColor = .blackColor()
            cellView.backgroundColor = UIColorFromRGB(0xF4A96E)
        }
        if indexPath.row == 3{
            icon.image = UIImage(named: "icon4.png")
            text.text = "考试地点"
            text.font = fontSize(20)
            text.textColor = .blackColor()
            cellView.backgroundColor = UIColorFromRGB(0xF9AEC3)
        }
        
        
        
        
        cell.addSubview(cellView)
        
        
        /*
        if indexPath.row == 0{
            let testView = UIImage(named: "icon1.png")
            cell.imageView?.image = testView
            //cell.imageView?.sizeToFit()
            cell.textLabel?.text = "顺序测试"
            cell.textLabel?.font = fontSize(20.0)
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.text = "顺序测试题库所有G1考试题目"
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.font = fontSize(10.0)
            cell.backgroundColor = UIColorFromRGB(0xffff00)
        }
        
        if indexPath.row == 1{
            
            let testView = UIImage(named: "icon2.png")
            cell.imageView?.image = testView
            //cell.imageView?.sizeToFit()
            cell.textLabel?.text = "随机测试"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = fontSize(20.0)
            cell.detailTextLabel?.text = "随机测试题库所有G1考试题目"
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.font = fontSize(10.0)
            cell.backgroundColor = UIColorFromRGB(0x68ff99)
        }
        
        if indexPath.row == 2{
            
            let testView = UIImage(named: "icon3.png")
            cell.imageView?.image = testView
            cell.imageView?.sizeToFit()
            cell.imageView?.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
            cell.textLabel?.text = "考试自测"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = fontSize(20.0)
            cell.detailTextLabel?.text = "20道交通标志题以及20道交通常识题"
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.font = fontSize(10.0)
            cell.backgroundColor = UIColorFromRGB(0x660066)
        }
        if indexPath.row == 3{
            let testView = UIImage(named: "icon3.png")
            cell.imageView?.image = testView
            cell.imageView?.sizeToFit()
            cell.textLabel?.text = "考试地点"
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = fontSize(20.0)
            cell.detailTextLabel?.text = "多伦多市4个G1考试地点"
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.font = fontSize(10.0)
            cell.backgroundColor = UIColorFromRGB(0x998877)
        }
        /*
        cell.sizeToFit()
        cell.textLabel?.text = "测试字体" + (fontList[indexPath.row] as! String) as! String
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.font = UIFont(name: fontList[indexPath.row] as! String, size: 20)
        //let cellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //cellLabel.text = "sdfasfdafs"
        //cell.contentView.addSubview(cellLabel)
        */
*/
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        /*
        if screenSize.width <= 320 {
            return 60
        }
        if screenSize.width <= 375 {
            return 60
        }
        */
        return 80
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView.tableHeaderView != nil{
            let header: ParallaxHeaderView = self.tableView.tableHeaderView as! ParallaxHeaderView
            header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
            self.tableView.tableHeaderView = header
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if indexPath.row == 0{
            let stvc = selfTestViewController()
            self.navigationController?.pushViewController(stvc, animated: true)
        }
        if indexPath.row == 1{
            let tvc = randomQuestion()
            //tvc.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            self.navigationController?.pushViewController(tvc, animated: true)
            //self.presentViewController(zl, animated: true, completion: nil)
        }
        if indexPath.row == 2{
            let vc = examViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 3{
            let el = examLocation()
            self.navigationController?.pushViewController(el, animated: true)
        }
    }
    func fontSize(basicSize: CGFloat) -> UIFont{
        if screenSize.width <= 320 {
            return UIFont(name: "Bradley Hand", size: basicSize)!
        }
        if screenSize.width <= 375 {
            return UIFont(name: "Bradley Hand", size: basicSize + 5)!
        }
        return UIFont(name: "Bradley Hand", size: basicSize + 10)!
    }
    
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
