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
    static let FormulaCellMultipleChoiceResuseIdentifier = "Formula Detail Cell Multiple Choice"
    static let UnitCellReuseIdentifier = "Unit Cell"

    static let ShowFormulaSegueIdentifier = "Formula Detail"
    static let ShowInputUnitSegue = "Input Unit Segue"
    static let ShowOutputUnitSegue = "Output Unit Segue"
    static let ComputeSegue = "Compute"
    static let MoreInfo = "More Info"
    
    static let FirstSectionHeader = "Design"
    static let SecondSectionHeader = "Precommissioning"
    static let RecentFormulas = "Recent"
    
    static let Titles = [["Pipeline Submerged Weight", "Maximum Allowable Working Pressure", "Temprature Drop Access Pipe Wall", "Pipe Wall Thickness"], ["Pressure Drop For Fluid Flow in Pipelines", "Chemical Dosing for Water Treatment", "Pipeline Internal Volume", "Dew Point Temperature", "Mean Flow Velocity"]]
    
    static let Inputs =
    //"Formula Name":["Input Name":("Unit Type","Unit Index","Predefined Value")]
    [
        "Pipeline Submerged Weight":["Pipeline Condition":("Multiple Choice",0,0), "Steel Pipe Outside Diameter":("Length",4,32.0), "Pipe Wall Thickness":("Length",2,20.0), "Corrosion Allowance":("Length",2,3.0), "Corrosion Coating Thickness":("Length",2,6.0), "Concrete Coating Thickness":("Length",2,40.0), "Marine Growth Thickness":("Length",2,20.0), "Steel Density":("Density",0,7850.0), "Product Density": ("Density",0,100.0), "Corrosion Coating Density": ("Density",0,980.0), "Concrete Coating Density": ("Density",0,3040.0), "Seawater Density": ("Density",0,1025.0), "Marine Growth Density": ("Density",0,1500.0), "Field Joint Density": ("Density",0,1250.0), "Joint Length": ("Length",0,12.0), "Corrosion Coating Cutback Length": ("Length",0,0.5), "Concrete Coating Cutback Length": ("Length",0,0.5)],
        
        "Dew Point Temperature":["Air Temperature":("Temperature",0,28.0), "Relative Humidity":("Percentage",0,75.0), "Air Pressure": ("Pressure",2,1.0) ]
    ]
    
    static let Units =
    [
        "Temperature":["°C","K","°F"],
        "Percentage":["%"],
        "Pressure":["Pa","kPa","bar","millibar","psi","ksi"],
        "Molar Density":["mole/m3", "mole/cm3", "mole/gallon", "mole/liter", "mole/ft3"],
        "Density": ["kg/m3", "g/cm3", "lb/ft3", "lb/in3", "g/m3", "kg/liter", "lb/gallon"],
        "Fraction":[""],
        "Inverse Volume":["1/cm3", "1/m3", "1/gallon", "1/liter", "1/ft3"],
        "Length": ["m", "cm", "mm", "ft", "in"],
        "Force Per Length": ["N/m", "kN/m", "kgf/m", "lbf/ft"]
    ]
}

class MainTableViewController: UITableViewController {
    
    private let savedData = NSUserDefaults()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        }
    }
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 44
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
            //Recent Section
            if let recentArray = savedData.arrayForKey(StringConstants.RecentFormulas) {
                cell.textLabel?.text = recentArray[indexPath.row] as? String
            }
        } else {
            cell.textLabel?.text = StringConstants.Titles[indexPath.section][indexPath.row]
            cell.imageView?.image = UIImage(named: "Formula\(indexPath.section+1)\(indexPath.row+1)")
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

