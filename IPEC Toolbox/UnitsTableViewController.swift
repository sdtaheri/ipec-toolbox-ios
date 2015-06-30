//
//  UnitsTableViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/28.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class UnitsTableViewController: UITableViewController {

    var unitsArray: [String]!
    var selectedUnit: String!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        if let selectedIndex = find(unitsArray, selectedUnit) {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0)) {
                cell.accessoryType = .Checkmark
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = CGSizeMake(150, tableView.contentSize.height)
        if let presentedView = self.popoverPresentationController?.presentedView() {
            if tableView.contentSize.height > presentedView.frame.size.height {
                tableView.scrollEnabled = true
            } else {
                tableView.scrollEnabled = false
            }
        }
        
        tableView.scrollEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.UnitCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = unitsArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        for row in 0..<tableView.numberOfRowsInSection(0) {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) {
                cell.accessoryType = .None
            }
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .Checkmark
            selectedUnit = cell.textLabel?.text
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
