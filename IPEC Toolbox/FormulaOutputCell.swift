//
//  FormulaOutputCell.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/29.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class FormulaOutputCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var unit: UIButton! {
        didSet {
            unit.contentHorizontalAlignment = .Left
            unit.titleLabel?.minimumScaleFactor = 0.5
            unit.titleLabel?.adjustsFontSizeToFitWidth = true
            unit.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        }
    }
    
}
