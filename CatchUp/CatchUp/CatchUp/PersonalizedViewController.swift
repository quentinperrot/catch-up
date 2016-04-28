//
//  PersonalizedViewController.swift
//  CatchUp
//
//  Created by Quentin Perrot on 4/27/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class PersonalizedViewController: UIViewController {
    
    var sections: Array<String> = []
    
    var pageMenu : CAPSPageMenu?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        let viewController = UIViewController()
//        viewController.title = "Menu title"
//        let viewControllers = [viewController]
//        
//        let options = PagingMenuOptions()
//        options.menuItemMargin = 5
//        options.menuDisplayMode = .SegmentedControl
//        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        
//        self.addChildViewController(pagingMenuController)
//        self.view.addSubview(pagingMenuController.view)
//        pagingMenuController.didMoveToParentViewController(self)
        
        
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        let controller = UIViewController()
        controller.title = "Sports"
        
        let controller2 = UIViewController()
        controller2.title = "Finance"
        
        let controller3 = UIViewController()
        controller3.title = "World"
        
        let controller4 = UIViewController()
        controller4.title = "Technology"
        
        let controller5 = UIViewController()
        controller5.title = "Design"
        
        controllerArray.append(controller)
        controllerArray.append(controller2)
        controllerArray.append(controller3)
        controllerArray.append(controller4)
        controllerArray.append(controller5)



        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        var parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(false),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 20, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)

        // Do any additional setup after loading the view.
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
