//
//  SectionPickerTableViewController.swift
//  CatchUp
//
//  Created by Quentin Perrot on 4/27/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit


class SectionPickerTableViewController: UITableViewController {
    
    var limit = 4

    let defaults = NSUserDefaults.standardUserDefaults()
    
    var sectionsDictionary: [String: String] = [
        "Engadget": "engadget.png",
        "Gizmodo": "gizmodo.png",
        "LifeHacker": "lifehacker.png",
        "Mashable": "mashable.png",
        "Medium": "medium.png",
        "NYT Tech": "newyorktimes.png",
        "TechCrunch": "techcrunch.png",
        "TechRadar": "techradar.png",
        "Wired": "wired.png"]
    
    var sectionsSelected: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100

        
        self.tableView.allowsMultipleSelection = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return sectionsDictionary.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        var sectionNames = Array(sectionsDictionary.keys)
        let sectionName = sectionNames[indexPath.row]
        let sectionImage = UIImage(named: sectionsDictionary[sectionName]!)
//        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
//        cell.imageView?.contentMode = UIViewContentMode.Center
//        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView?.image = sectionImage

        print(cell.imageView?.frame.width)
        
        let itemSize = CGSizeMake(150, 30)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale)
        let imageRect = CGRectMake((375/2)-(150/2), 0.0, itemSize.width, itemSize.height)
        cell.imageView?.image?.drawInRect(imageRect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        sectionsSelected.insert(Array(sectionsDictionary.keys)[indexPath.row])
        defaults.setObject(Array(sectionsSelected), forKey: "sections")
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        sectionsSelected.remove(Array(sectionsDictionary.keys)[indexPath.row])
        defaults.setObject(Array(sectionsSelected), forKey: "sections")
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        Optimizely.codeBlocksWithKey(sectionNumberBlockKey,
                                     blockOne: { self.limit = 3 },
                                     defaultBlock: { self.limit = 4 })
    
        if let sr = tableView.indexPathsForSelectedRows {
            if sr.count == limit {
                let alertController = UIAlertController(title: "Limit Reached", message:
                    "You are limited to \(limit) topic selections", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return nil
            }
        }
        
        return indexPath
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Load live variable
//        var key = OptimizelyVariableKey.optimizelyKeyWithKey("myKey", defaultNSString: "myValue")
//        var liveVariable:String = Optimizely.stringForKey(key)
//        
//        // Use the liveVariable
//        if(liveVariable == "VarA") {
//            var alert:UIAlertView = UIAlertView(title: "AB Test", message: "This alert only shows if liveVariable equals VarA", delegate: self, cancelButtonTitle: "Close")
//            alert.show()
//        }
//        
//        print(defaults.objectForKey("sections"))
    }

}
