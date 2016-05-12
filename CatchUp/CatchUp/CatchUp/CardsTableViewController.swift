//
//  CardsTableViewController.swift
//  CatchUp
//
//  Created by Asad Khaliq on 4/28/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import SafariServices

class CardsTableViewController: UITableViewController, SFSafariViewControllerDelegate, XMLParserDelegate {
    
    var xmlParser : XMLParser!
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }
    
    var tableRowNumber = 5
    
    var sectionsDictionary: [String: String] = [
        "Sports": "http://www.nytimes.com/services/xml/rss/nyt/Sports.xml",
        "Technology": "http://feeds.nytimes.com/nyt/rss/Technology",
        "Business": "http://feeds.nytimes.com/nyt/rss/Business",
        "Science": "http://www.nytimes.com/services/xml/rss/nyt/Science.xml",
        "Health": "http://www.nytimes.com/services/xml/rss/nyt/Health.xml",
        "Arts": "http://www.nytimes.com/services/xml/rss/nyt/Arts.xml",
        "Style": "http://www.nytimes.com/services/xml/rss/nyt/FashionandStyle.xml",
        "Travel": "http://www.nytimes.com/services/xml/rss/nyt/Travel.xml",
        "World": "http://www.nytimes.com/services/xml/rss/nyt/World.xml",
        "Popular": "http://www.nytimes.com/services/xml/rss/nyt/MostViewed.xml",
        "Trending": "http://www.nytimes.com/services/xml/rss/nyt/MostShared.xml",
        "Most Shared": "http://www.nytimes.com/services/xml/rss/nyt/pop_top.xml"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 425
        
        self.edgesForExtendedLayout = UIRectEdge.All
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom:49.0, right: 0.0)

        print(self.title)
        
        let url = NSURL(string: sectionsDictionary[self.title!]!)
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url!)

       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableRowNumber
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CardTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CardCell", forIndexPath: indexPath) as! CardTableViewCell
        let currentDictionary = xmlParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        if (currentDictionary["pubDate"] != nil) {
        let date = NSDate(fromString:currentDictionary["pubDate"]!, format: .RSS)
            print(date)
            cell.dateLabel?.text = date.relativeTimeToString()

        } else {
            cell.dateLabel?.text = "Now"
        }
//        let now = NSDate()
//        let timePassed = date.hoursAfterDate(now)
//

        cell.mainLabel?.text = currentDictionary["title"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        cell.contentLabel?.text = currentDictionary["description"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dictionary = xmlParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        let link = dictionary["link"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        print(link)
        let svc = SFSafariViewController(URL: NSURL(string: link)!)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
    }

    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.edgesForExtendedLayout = UIRectEdge.All
  //      self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
//
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            
            let seconds = 2.3
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                
                var refreshAlert = UIAlertController(title: "You're Caught Up!", message: "You got to the end of that section! Congratulations on brushing up on the current news.", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Great!", style: .Default, handler: { (action: UIAlertAction!) in
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Load More News", style: .Default, handler: { (action: UIAlertAction!) in
                    self.tableRowNumber += 5
                    self.tableView.reloadData()
                }))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
            })
            
            
        }
    }
    
    
    @IBAction func shareClicked(sender: AnyObject) {
        let textToShare = "Here's an awesome link I found whilst using the loop app!"
        
        if let myWebsite = NSURL(string: "http://google.com/") {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        
        var refreshAlert = UIAlertController(title: "Whoops!", message: "We're still working on that feature. Coming soon!", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cool", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
