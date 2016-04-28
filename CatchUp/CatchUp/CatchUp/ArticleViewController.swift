//
//  ArticleViewController.swift
//  CatchUp
//
//  Created by Quentin Perrot on 4/28/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    
    @IBOutlet weak var webview: UIWebView!
    
    var publishDate: String!
    
    var articleDescription: String!
    
    var articleURL: NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if articleURL != nil {
            print(articleURL)
            print(publishDate)
            print(articleDescription)
            let request : NSURLRequest = NSURLRequest(URL: articleURL)
            webview.loadRequest(request)
            
            if webview.hidden {
                webview.hidden = false
            }
        }
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
