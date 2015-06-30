//
//  AboutViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/23.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var ipecTextView: UITextView!
    @IBOutlet weak var redcubeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ipecTextView.scrollRangeToVisible(NSMakeRange(0, 1))
        redcubeTextView.scrollRangeToVisible(NSMakeRange(0, 1))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
