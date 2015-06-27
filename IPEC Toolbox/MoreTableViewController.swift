//
//  MoreTableViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/23.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    private var selectedIndexPath: NSIndexPath?
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("moreCell", forIndexPath: indexPath) as! UITableViewCell

        switch indexPath.row {
        case 0: cell.textLabel?.text = "About Us"
        case 1: cell.textLabel?.text = "Share This App"
        case 2: cell.textLabel?.text = "Contact Us"
        case 3: cell.textLabel?.text = "Rate Us"
        default: break
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier("About Segue", sender: nil)
        }
        selectedIndexPath = indexPath
    }
    
    @IBAction func dismissAboutController(sender: UIStoryboardSegue) {
        if selectedIndexPath != nil {
            tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

}
