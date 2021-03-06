//
//  PersonalizedViewController.swift
//  CatchUp
//
//  Created by Quentin Perrot on 4/27/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Optimizely

class PersonalizedViewController: UIViewController {
    
    var sections: Array<String> = []
    
    var pageMenu : CAPSPageMenu?
    
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        
        let allSectionsChosen = defaults.objectForKey("sections") as! [String]
        
        for section in allSectionsChosen {
            let vc = storyboard!.instantiateViewControllerWithIdentifier("cardsViewController")
            vc.title = section
            controllerArray.append(vc)
        }
        
        let colorBar = UIColor(netHex:0x18A9FF)
        let colorUnselected = UIColor(netHex:0xDFDFDF)

        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(false),
            .MenuItemSeparatorPercentageHeight(0.1),
            .ScrollMenuBackgroundColor(colorBar),
            .UnselectedMenuItemLabelColor(UIColor.whiteColor()),
            .MenuHeight(50)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
//        
//        let progressInit = ProgressView
//        self.view.addSubview(progessInit.view)
        
        
//        makeProgressBar(1)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        
        // Log Event 
        Flurry.logEvent("User_Opened_Source_Tab")
        
        let allSectionsChosen = defaults.objectForKey("sections") as! [String]
        
        for section in allSectionsChosen {
            let vc = storyboard!.instantiateViewControllerWithIdentifier("cardsViewController")
            vc.title = section
            controllerArray.append(vc)
        }
        
        let colorBar = UIColor(netHex:0x18A9FF)
        let colorUnselected = UIColor(netHex:0xDFDFDF)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(false),
            .MenuItemSeparatorPercentageHeight(0.1),
            .ScrollMenuBackgroundColor(colorBar),
            .UnselectedMenuItemLabelColor(UIColor.whiteColor()),
            .MenuHeight(50)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
        //
        //        let progressInit = ProgressView
        //        self.view.addSubview(progessInit.view)
        
        
        //        makeProgressBar(1)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    public func makeProgressBar(value: Int) {
        let testFrame : CGRect = CGRectMake(0,610,375,8)
        var testView : ProgressView = ProgressView(frame: testFrame)
        testView.cellsScrolledChange(value)
        self.view.addSubview(testView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
