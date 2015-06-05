//
//  FormulaInputCell.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/27.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class FormulaInputCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var unitLabel: UIButton! {
        didSet {
            unitLabel.titleLabel?.minimumScaleFactor = 0.5
            unitLabel.titleLabel?.adjustsFontSizeToFitWidth = true
            unitLabel.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        }
    }
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
