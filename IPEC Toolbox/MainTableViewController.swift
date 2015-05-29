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
    static let FormulaCellReuseIdentifier = "Formula Detail Cell"
    static let UnitCellReuseIdentifier = "Unit Cell"

    static let ShowFormulaSegueIdentifier = "Formula Detail"
    static let ShowUnitSegue = "Unit Segue"
    static let ComputeSegue = "Compute"
    static let MoreInfo = "More Info"
    
    static let FirstSectionHeader = "Design"
    static let SecondSectionHeader = "Precommissioning"
    static let RecentFormulas = "Recent"
    
    static let Titles = [["Pipeline Submerged Weight", "Maximum Allowable Working Pressure", "Temprature Drop Access Pipe Wall", "Pipe Wall Thickness"], ["Pressure Drop For Fluid Flow in Pipelines", "Chemical Dosing for Water Treatment", "Pipeline Internal Volume", "Dew Point Temperature", "Mean Flow Velocity"]]
    
    static let Inputs =
    [
        "Dew Point Temperature":["Air Temperature":"Temperature", "Relative Humidity":"Percentage", "Air Pressure": "Pressure" ]
    ]
    
    static let Units =
    [
        "Temperature":["°C","K","°F"],
        "Percentage":["%"],
        "Pressure":["Pa","kPa","bar","millibar","psi","ksi"],
        "Molar Density":["mole/m3", "mole/cm3", "mole/gallon", "mole/liter", "mole/ft3"],
        "Density": ["kg/m3", "g/cm3", "lb/ft3", "lb/in3", "g/m3"],
        "Fraction":[""],
        "Inverse Volume":["1/cm3", "1/m3", "1/gallon", "1/liter", "1/ft3"]
    ]
}

class MainTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    private let savedData = NSUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
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
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        
        if splitViewController.collapsed {
            if let master = splitViewController.viewControllers[0] as? UITabBarController {
                if let masterNC = master.selectedViewController as? UINavigationController {
                    masterNC.pushViewController(vc, animated: true)
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController!) -> UIViewController? {
        if let master = splitViewController.viewControllers[0] as? UITabBarController {
            if let masterNC = master.selectedViewController as? UINavigationController {
                if let lastController = masterNC.childViewControllers.last as? UINavigationController {
                    masterNC.popViewControllerAnimated(true)
                    return lastController
                }
            }
        }
        
        return nil
    }
    
}

