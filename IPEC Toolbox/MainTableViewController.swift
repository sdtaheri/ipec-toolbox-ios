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
    
    static let Titles = [["Pipeline Submerged Weight", "Maximum Allowable Working Pressure", "Temperature Drop Across Pipe Wall", "Pipe Wall Thickness"], ["Pressure Drop For Fluid Flow in Pipelines", "Chemical Dosing for Water Treatment", "Pipeline Internal Volume", "Dew Point Temperature", "Mean Flow Velocity"]]
    
    static let Inputs: [String: [String:(String,Int,Double)]] =
    //"Formula Name":["Input Name":("Unit Type","Unit Index","Predefined Value")]
    [
        "Pipeline Submerged Weight":["Pipeline Condition":("Multiple Choice",0,0), "Steel Pipe Outside Diameter":("Length",4,32.0), "Pipe Wall Thickness":("Length",2,20.0), "Corrosion Allowance":("Length",2,3.0), "Corrosion Coating Thickness":("Length",2,6.0), "Concrete Coating Thickness":("Length",2,40.0), "Marine Growth Thickness":("Length",2,20.0), "Steel Density":("Density",0,7850.0), "Product Density": ("Density",0,100.0), "Corrosion Coating Density": ("Density",0,980.0), "Concrete Coating Density": ("Density",0,3040.0), "Seawater Density": ("Density",0,1025.0), "Marine Growth Density": ("Density",0,1500.0), "Field Joint Density": ("Density",0,1250.0), "Joint Length": ("Length",0,12.0), "Corrosion Coating Cutback Length": ("Length",0,0.5), "Concrete Coating Cutback Length": ("Length",0,0.5)],
        
        "Maximum Allowable Working Pressure": ["Yield Stress":("Pressure",5,20.0), "Pipeline Outside Diameter":("Length",4,32.0), "Pipeline Wall Thickness": ("Length",4,0.5), "Joint Efficiency":("Multiple Choice",0,0)],
        
        "Temperature Drop Across Pipe Wall": ["Nominal Outer Diameter": ("Length",4,32.0),  "Fluid Temperature": ("Temperature",0,25.0), "Ambient Temperature": ("Temperature",0,25.0), "Pipe Wall Thickness": ("Length",4,0.5), "Coating Thickness": ("Length",4,0.5), "Concrete Thickness": ("Length",4,0.5), "Pipeline Buried Height": ("Length",1,50.0), "Pipeline Thermal Conductivity": ("Thermal Conductivity",0,43.0), "Coating Thermal Conductivity": ("Thermal Conductivity",0,43.0), "Ambient Fluid Density": ("Density",0,998.2), "Internal Fluid Density": ("Density",0,998.2), "Ambient Fluid Viscosity": ("Viscosity",0,1.002/1000), "Internal Fluid Viscosity": ("Viscosity",0,1.002/1000), "Ambient Fluid Heat Capacity": ("Heat Capacity",0,4200.0), "Internal Fluid Heat Capacity": ("Heat Capacity",0,4200.0), "Ambient Fluid Thermal Conductivity": ("Thermal Conductivity",0,0.56), "Internal Fluid Thermal Conductivity": ("Thermal Conductivity",0,0.56), "Internal Fluid Volumetric Flow Rate": ("Volume Rate",2,500.0), "Ambient Fluid Velocity": ("Speed",0,20.0), "Concrete Thermal Conductivity": ("Thermal Conductivity",0,43.0), "Soil Thermal Conductivity": ("Thermal Conductivity",0,1.5)],
        
        "Pipe Wall Thickness": ["Pipeline Design Pressure": ("Pressure",2,20.0), "Pipeline Ouside Diameter": ("Length",4,32.0), "Specified Minimum Yield Stress (SMYS)": ("Pressure",6,250.0), "Pipeline Production": ("Multiple Choice",0,0), "Location Class (For Human Occupancy)": ("Multiple Choice",0,0)],
        
        "Pressure Drop For Fluid Flow in Pipelines": ["Volumetric Flow Rate": ("Volume Rate",2,500.0), "Pipeline Outside Diameter": ("Length",4,32.0), "Pipeline Wall Thickness": ("Length",4,0.5), "Pipeline Length": ("Length",0,3500.0), "Surface Roughness": ("Length",2,0.1), "Fluid Dynamic Viscosity": ("Viscosity",0,1.002/1000), "Fluid Density": ("Density",0,998.2), "Pipeline Inlet Elevation": ("Length",0,10.0), "Pipeline Outlet Elevation": ("Length",0,10.0)],
        
        "Dew Point Temperature":["Air Temperature":("Temperature",0,28.0), "Relative Humidity":("Percentage",0,75.0), "Air Pressure": ("Pressure",2,1.0) ]
    ]
    
    static let Units: [String:[String]] =
    [
        "Temperature":["°C","K","°F"],
        "Percentage":["%"],
        "Pressure":["Pa","kPa","bar","millibar","psi","ksi", "MPa", "GPa"],
        "Molar Density":["mole/m3", "mole/cm3", "mole/gal", "mole/L", "mole/ft3"],
        "Density": ["kg/m3", "g/cm3", "lb/ft3", "lb/in3", "g/m3", "kg/L", "lb/gal"],
        "Fraction":[""],
        "Inverse Volume":["1/cm3", "1/m3", "1/gal", "1/L", "1/ft3"],
        "Length": ["m", "cm", "mm", "ft", "in"],
        "Force Per Length": ["N/m", "kN/m", "kgf/m", "lbf/ft"],
        "Volume Rate": ["m3/s", "m3/min", "m3/hr", "L/s", "L/min", "L/hr", "gal/s", "gal/min", "gal/hr"],
        "Viscosity": ["Pa.s", "N.s/m2", "Poise", "cPoise", "lb.s/ft2", "lb.s/in2"],
        "Speed": ["m/s", "km/h", "ft/s"],
        "Heat Capacity": ["J/(kg.°C)", "J/(kg.K)", "Btu/(lbm.R)"],
        "Thermal Conductivity": ["W/(m.°C)", "W/(m.K)", "Cal/(m.hr.K)", "Btu/(ft.hr.R)"],
        "Power Per Length": ["W/m", "Cal/(m.hr)", "Btu/(ft.hr)"]
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

