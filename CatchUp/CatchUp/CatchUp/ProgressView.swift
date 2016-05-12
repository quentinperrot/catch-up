//
//  ProgressView.swift
//  CatchUp
//
//  Created by Asad Khaliq on 5/11/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    public var cellsScrolled = 1
    
    override func drawRect(rect: CGRect) {
        if cellsScrolled == 1 {
            ProgressBar.drawCanvas1()
        }
        if cellsScrolled == 3 {
            ProgressBar.drawCanvas3()
        }
    }
    
    public func cellsScrolledChange(change: Int) {
        cellsScrolled = change
    }

}
