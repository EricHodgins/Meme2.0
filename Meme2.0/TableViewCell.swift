//
//  TableViewCell.swift
//  Meme2.0
//
//  Created by Eric Hodgins on 2015-12-21.
//  Copyright © 2015 Eric Hodgins. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var topTextFieldLabel: UILabel!
    @IBOutlet weak var bottomTextFieldLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
