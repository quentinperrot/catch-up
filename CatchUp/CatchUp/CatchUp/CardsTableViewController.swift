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
    
    // Asycnhronous Loading Properties
    
    var refreshCtrl: UIRefreshControl!
    var tableData:[AnyObject]!
    var task: NSURLSessionDownloadTask!
    var session: NSURLSession!
    var cache: NSCache!
    var notieShown = 0
    var testView: ProgressView!
    var overlayView: UIView?
    
    var xmlParser : XMLParser!
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }
    
    public var cellsScrolled = 1
    
    var tableRowNumber = 5
    
    var sectionsDictionary: [String: String] = [
        "Engadget": "http://www.engadget.com/rss.xml",
        "Gizmodo": "http://feeds.gawker.com/gizmodo/full",
        "LifeHacker": "http://feeds.gawker.com/lifehacker/full#_ga=1.99577438.1966049348.146237840",
        "Mashable": "http://feeds.mashable.com/Mashable?format=xml",
        "Medium": "https://medium.com/feed/@Medium",
        "New York Times Technology": "http://rss.nytimes.com/services/xml/rss/nyt/Technology.xml",
        "TechCrunch": "http://techcrunch.com/feed/",
        "TechRadar": "http://feeds.webservice.techradar.com/us/rss",
        "Wired": "http://www.wired.com/feed/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 425
        self.edgesForExtendedLayout = UIRectEdge.All
        self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom:50.0, right: 0.0)
        
        // Parser commands
        let url = NSURL(string: sectionsDictionary[self.title!]!)
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url!)
        if !xmlParser.arrParsedData.isEmpty { xmlParser.arrParsedData.removeFirst() }
        
        // Asynchronous Loading commands
        session = NSURLSession.sharedSession()
        task = NSURLSessionDownloadTask()
        
        self.tableData = []
        self.cache = NSCache()
        
        makeProgressBar(1)
        
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    public func makeProgressBar(value: Int) {
        let testFrame : CGRect = CGRectMake(0,560,375,8)
        testView = ProgressView(frame: testFrame)
        testView.cellsScrolledChange(value)
        self.view.addSubview(testView)
        
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
        var imageLinks = [String]()
        var imageLink = ""
        
        // Set Publication
        cell.publicationLabel?.text = self.title
        
        
        // Find Date
        if (currentDictionary["pubDate"] != nil) {
            let date = NSDate(fromString:currentDictionary["pubDate"]!, format: .RSS)
            cell.dateLabel?.text = date.relativeTimeToString()
        } else {
            cell.dateLabel?.text = "Now"
        }
        
        // Find Title
        if (currentDictionary["title"] != nil) {
            cell.mainLabel?.text = currentDictionary["title"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        // Find Description
        if (currentDictionary["description"] != nil) {
            // Set Description
            var description = currentDictionary["description"]!
            cell.contentLabel?.text = description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).html2String
            
            
            // Find Image Link for certain RSS Feeds
            if imageLinks.isEmpty {
                let regex = try! NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: [])
                let range = NSMakeRange(0, description.characters.count)
                regex.enumerateMatchesInString(description, options: [], range: range) { (result, _, _) -> Void in
                    let nsrange = result!.rangeAtIndex(2)
                    let start = description.startIndex.advancedBy(nsrange.location)
                    let end = start.advancedBy(nsrange.length)
                    var link = description[start..<end].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    imageLinks.append(link)
                    imageLink = imageLinks[0]
                }
            }
            
            // Find link if not found in Description
            if imageLinks.isEmpty {
                if currentDictionary["media:description"] != nil {
                    imageLink = currentDictionary["media:description"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                } else if currentDictionary["media:title"] != nil {
                    imageLink = currentDictionary["media:title"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                }
            }
            
            // Load Image
            if (self.cache.objectForKey(imageLink) != nil) {
                cell.cardImage.image = self.cache.objectForKey(imageLink) as? UIImage
            } else {
                let url = NSURL(string: imageLink)
                asynchronousLoading(url!, indexPath: indexPath, tableView: tableView, key: imageLink, cell: cell)
            }
        }
        
        
        return cell
    }
    
    func asynchronousLoading(url: NSURL, indexPath: NSIndexPath, tableView: UITableView, key: String, cell: CardTableViewCell) {
        self.task = self.session.downloadTaskWithURL(url, completionHandler: { (location, response, error) -> Void in
            if let data = NSData(contentsOfURL: url){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let img: UIImage! = UIImage(data: data)
                    cell.cardImage.image = img
                    self.cache.setObject(img, forKey: key)
                })
            }
        })
        self.task.resume()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dictionary = xmlParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        let link = dictionary["link"]!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if link != "" {
            let svc = SFSafariViewController(URL: NSURL(string: link)!)
            svc.delegate = self
            self.presentViewController(svc, animated: true, completion: nil)
            
            // Log event
            let articleParams = ["Source Name": String(self.title!)]
            Flurry.logEvent("Article_Read", withParameters: articleParams)
        }
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.edgesForExtendedLayout = UIRectEdge.All
        //      self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        //
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var fixedFrame = self.testView.frame;
        fixedFrame.origin.y = 560 + scrollView.contentOffset.y;
        self.testView.frame = fixedFrame;
        cellsScrolled = 1
        
        if (overlayView != nil) {
            var overlayFixed = self.overlayView!.frame
            fixedFrame.origin.y = scrollView.contentOffset.y
            self.overlayView!.frame = fixedFrame
        }
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= 875) {
            testView.removeFromSuperview()
            makeProgressBar(2)
            var fixedFrame = self.testView.frame;
            fixedFrame.origin.y = 560 + scrollView.contentOffset.y;
            self.testView.frame = fixedFrame;
        }
        
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= 1310) {
            testView.removeFromSuperview()
            makeProgressBar(3)
            var fixedFrame = self.testView.frame;
            fixedFrame.origin.y = 560 + scrollView.contentOffset.y;
            self.testView.frame = fixedFrame;
        }
        
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= 1725) {
            testView.removeFromSuperview()
            makeProgressBar(4)
            var fixedFrame = self.testView.frame;
            fixedFrame.origin.y = 560 + scrollView.contentOffset.y;
            self.testView.frame = fixedFrame;
        }
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= 2120) {
            print(scrollView.contentSize.height)
            testView.removeFromSuperview()
            makeProgressBar(5)
            var fixedFrame = self.testView.frame;
            fixedFrame.origin.y = 560 + scrollView.contentOffset.y;
            self.testView.frame = fixedFrame;
            
            
            // CAUGHT UP
            
            let seconds = 1.3
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            if (self.notieShown == 0) {

            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.overlayView = UIView(frame: CGRectMake(0, scrollView.contentOffset.y, self.view.frame.size.width, self.view.frame.size.height))
                
                //                                    let imageName = "newyorktimes.png"
                //                                    let image = UIImage(named: imageName)
                //                                    let imageView = UIImageView(image: image!)
                //
                //                                    imageView.frame = CGRectMake(0, 0, 300, 300) // set up according to your requirements
                //
                //                                    var doneBtn : UIButton = UIButton(frame: CGRectMake(0, 0, 100, 100)) // set up according to your requirements
                //                                    doneBtn.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
                //
                //                                    overlay.addSubview(imageView)
                
                self.view.addSubview(self.overlayView!)
                
                
                let notie = Notie(view: self.overlayView!, message: "You're all caught up with \(self.title!)!", style: .Confirm)
                
                notie.leftButtonTitle = "Great!"
                notie.rightButtonTitle = "Load More News"
                
                notie.leftButtonAction = {
                    // Add your left button action here
                    notie.dismiss()
                }
                
                notie.rightButtonAction = {
                    self.tableRowNumber += 5
                    self.tableView.reloadData()
                    notie.dismiss()
                }
                
                    notie.show()
                
            })
                self.notieShown = 1
            }
            
            
            // END CAUGHT UP
            
            
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


extension String {
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
