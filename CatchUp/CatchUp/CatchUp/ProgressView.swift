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
        if cellsScrolled == 2 {
            ProgressBar.drawCanvas2()
        }
        if cellsScrolled == 3 {
            ProgressBar.drawCanvas3()
        }
        if cellsScrolled == 4 {
            ProgressBar.drawCanvas4()
        }
        if cellsScrolled == 5 {
            ProgressBar.drawCanvas5()
        }
    }
    
    public func cellsScrolledChange(change: Int) {
        cellsScrolled = change
    }

}
