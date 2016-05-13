//
//  CardTableViewCell.swift
//  CatchUp
//
//  Created by Asad Khaliq on 4/28/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLogo: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var articleLogo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
