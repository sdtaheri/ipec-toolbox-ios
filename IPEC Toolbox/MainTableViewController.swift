//
//  ViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/23.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

struct StringConstants {
    static let MainCellReuseIdentifier = "Main Cell"
    static let ShowFormulaSegueIdentifier = "Formula Detail"
    
    static let FormulaCellReuseIdentifier = "Formula Detail Cell"
    static let ShowUnitSegue = "Unit Segue"
    
    static let UnitCellReuseIdentifier = "Unit Cell"
    
    static let FirstSectionHeader = "Design"
    static let SecondSectionHeader = "Precommissioning"
    static let RecentFormulas = "Recent"
    
    static let Titles = [["Pipeline Submerged Weight", "Maximum Allowable Working Pressure", "Temprature Drop Access Pipe Wall", "Pipe Wall Thickness"], ["Pressure Drop For Fluid Flow in Pipelines", "Chemical Dosing for Water Treatment", "Pipeline Internal Volume", "Dew Point Temperature", "Mean Flow Velocity"]]
    
    static let Inputs = ["Dew Point Temperature":["Air Temperature":["°C","K","°F"], "Relative Humidity":["%"], "Air Pressure":["Pa","kPa","psi"] ]]
}

class MainTableViewController: UITableViewController {
    
    private let savedData = NSUserDefaults()

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            var recentSectionCount = 0;
            if let recentFormulas = savedData.arrayForKey(StringConstants.RecentFormulas) {
                recentSectionCount = recentFormulas.count
            }
            return recentSectionCount
        } else {
            return StringConstants.Titles[section].count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.MainCellReuseIdentifier) as! UITableViewCell
        
        if indexPath.section == 2 {
            if let recentArray = savedData.arrayForKey(StringConstants.RecentFormulas) {
                cell.textLabel?.text = recentArray[indexPath.row] as? String
            }
        } else {
            cell.textLabel?.text = StringConstants.Titles[indexPath.section][indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return StringConstants.FirstSectionHeader
        case 1: return StringConstants.SecondSectionHeader
        case 2:
            if let recentFormulas = savedData.arrayForKey(StringConstants.RecentFormulas) {
                return StringConstants.RecentFormulas
            } else {
                return nil
            }
        default: return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StringConstants.ShowFormulaSegueIdentifier {
            if let cell = sender as? UITableViewCell {
                if let dvc = segue.destinationViewController as? FormulaDetailTableViewController {
                    dvc.selectedIndexPath = tableView.indexPathForCell(cell)
                }
            }
        }
    }
        
}

