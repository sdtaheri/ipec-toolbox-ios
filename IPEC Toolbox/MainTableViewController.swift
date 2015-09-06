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
    
    static let FormulaDetailTutorial = "Formula Detail Tutorial"
    static let ResultsTutorial = "Results Tutorial"

    
    static let Titles = [["Pipeline Submerged Weight", "Maximum Allowable Working Pressure", "Temperature Drop Across Pipe Wall", "Pipe Wall Thickness"], ["Pressure Drop for Fluid Flow in Pipelines", "Inhibitor Chemical and Sea Dye Injection Rate", "Pipeline Internal Volume", "Dew Point Temperature", "Mean Flow Velocity"]]
    
    static let Inputs: [String: [String:(String,Int,Double)]] =
    //"Formula Name":["Input Name":("Unit Type","Unit Index","Predefined Value")]
    [
        "Pipeline Submerged Weight":["Pipeline Condition":("Multiple Choice",0,0), "Steel Pipe Outside Diameter":("Length",4,32.0), "Pipe Wall Thickness":("Length",2,20.0), "Corrosion Allowance":("Length",2,3.0), "Corrosion Coating Thickness":("Length",2,6.0), "Concrete Coating Thickness":("Length",2,40.0), "Marine Growth Thickness":("Length",2,20.0), "Steel Density":("Density",0,7850.0), "Product Density": ("Density",0,100.0), "Corrosion Coating Density": ("Density",0,980.0), "Concrete Coating Density": ("Density",0,3040.0), "Seawater Density": ("Density",0,1025.0), "Marine Growth Density": ("Density",0,1500.0), "Field Joint Density": ("Density",0,1250.0), "Joint Length": ("Length",0,12.0), "Corrosion Coating Cutback Length": ("Length",0,0.5), "Concrete Coating Cutback Length": ("Length",0,0.5)],
        
        "Maximum Allowable Working Pressure": ["Yield Stress":("Pressure",5,20.0), "Pipeline Outside Diameter":("Length",4,32.0), "Pipeline Wall Thickness": ("Length",4,0.5), "Joint Efficiency":("Multiple Choice",0,0)],
        
        "Temperature Drop Across Pipe Wall": ["Nominal Outer Diameter": ("Length",4,32.0),  "Fluid Temperature": ("Temperature",0,25.0), "Ambient Temperature": ("Temperature",0,25.0), "Pipe Wall Thickness": ("Length",4,0.5), "Coating Thickness": ("Length",4,0.5), "Concrete Thickness": ("Length",4,0.5), "Pipeline Buried Height": ("Length",1,50.0), "Pipeline Thermal Conductivity": ("Thermal Conductivity",0,43.0), "Coating Thermal Conductivity": ("Thermal Conductivity",0,43.0), "Ambient Fluid Density": ("Density",0,998.2), "Internal Fluid Density": ("Density",0,998.2), "Ambient Fluid Viscosity": ("Viscosity",0,1.002/1000), "Internal Fluid Viscosity": ("Viscosity",0,1.002/1000), "Ambient Fluid Heat Capacity": ("Heat Capacity",0,4200.0), "Internal Fluid Heat Capacity": ("Heat Capacity",0,4200.0), "Ambient Fluid Thermal Conductivity": ("Thermal Conductivity",0,0.56), "Internal Fluid Thermal Conductivity": ("Thermal Conductivity",0,0.56), "Internal Fluid Volumetric Flow Rate": ("Volume Rate",2,500.0), "Ambient Fluid Velocity": ("Speed",0,20.0), "Concrete Thermal Conductivity": ("Thermal Conductivity",0,43.0), "Soil Thermal Conductivity": ("Thermal Conductivity",0,1.5)],
        
        "Pipe Wall Thickness": ["Pipeline Design Pressure": ("Pressure",2,20.0), "Pipeline Ouside Diameter": ("Length",4,32.0), "Specified Minimum Yield Stress (SMYS)": ("Pressure",6,250.0), "Pipeline Production": ("Multiple Choice",0,0), "Location Class (For Human Occupancy)": ("Multiple Choice",0,0)],
        
        "Pressure Drop for Fluid Flow in Pipelines": ["Volumetric Flow Rate": ("Volume Rate",2,500.0), "Pipeline Outside Diameter": ("Length",4,32.0), "Pipeline Wall Thickness": ("Length",4,0.5), "Pipeline Length": ("Length",0,3500.0), "Surface Roughness": ("Length",2,0.1), "Fluid Dynamic Viscosity": ("Viscosity",0,1.002/1000), "Fluid Density": ("Density",0,998.2), "Pipeline Inlet Elevation": ("Length",0,10.0), "Pipeline Outlet Elevation": ("Length",0,10.0)],
        
        "Inhibitor Chemical and Sea Dye Injection Rate": ["Pump Station Flow Rate": ("Volume Rate",2,500.0), "Inhibitor Chemical Dosage": ("Dosage",0,800.0), "Sea Dye Dosage": ("Dosage",0,50.0), "Pipeline Outside Diameter":("Length",4,32.0), "Pipeline Wall Thickness": ("Length",4,0.5), "Pipeline Length": ("Length",0,3500.0), "Inhibitor Chemical Density": ("Density",0,1100.0), "Sea Dye Density": ("Density",0,1040.0), "Ratio of Flooding Volume to Pipeline Volume": ("Fraction",0,1.1)],
        
        "Pipeline Internal Volume": ["Pipeline Length":("Length",0,2500.0), "Pipeline Outside Diameter":("Length",4,32.0), "Pipeline Wall Thickness":("Length",4,0.5)],
        
        "Dew Point Temperature":["Air Temperature":("Temperature",0,28.0), "Relative Humidity":("Percentage",0,75.0), "Air Pressure": ("Pressure",2,1.0) ],
        
        "Mean Flow Velocity": ["Pipeline Outside Diameter":("Length",4,32.0), "Pipeline Wall Thickness":("Length",4,0.5), "Volumetric Flow Rate": ("Volume Rate",2,500.0)],

    ]
    
    static let Units: [String:[String]] =
    [
        "Temperature":["°C","K","°F"],
        "Percentage":["%"],
        "Pressure":["Pa","kPa","bar","millibar","psi","ksi", "MPa", "GPa"],
        "Molar Density":["mole/m³", "mole/cm³", "mole/gal", "mole/L", "mole/ft³"],
        "Density": ["kg/m³", "g/cm³", "lb/ft³", "lb/in³", "g/m³", "kg/L", "lb/gal"],
        "Fraction":[""],
        "Inverse Volume":["1/cm³", "1/m³", "1/gal", "1/L", "1/ft³"],
        "Length": ["m", "cm", "mm", "ft", "in", "mi", "km"],
        "Force Per Length": ["N/m", "kN/m", "kgf/m", "lbf/ft"],
        "Volume Rate": ["m³/s", "m³/min", "m³/hr", "L/s", "L/min", "L/hr", "gal/s", "gal/min", "gal/hr", "ft³/s", "ft³/min", "ft³/hr"],
        "Viscosity": ["Pa.s", "N.s/m²", "Poise", "cPoise", "lb.s/ft²", "lb.s/in²"],
        "Speed": ["m/s", "km/h", "ft/s"],
        "Heat Capacity": ["J/(kg.°C)", "J/(kg.K)", "Btu/(lbm.R)"],
        "Thermal Conductivity": ["W/(m.°C)", "W/(m.K)", "Cal/(m.hr.K)", "Btu/(ft.hr.R)"],
        "Power Per Length": ["W/m", "Cal/(m.hr)", "Btu/(ft.hr)"],
        "Dosage": ["ppm"],
        "Volume": ["m³", "cm³", "L", "ft³", "mi³", "gallon", "barrel"],
        "Mass": ["kg", "g", "ton", "lb"]
    ]
}

class MainTableViewController: UITableViewController {
    
    private let userDefaults = NSUserDefaults()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        }
    }
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 44
        tableView.contentInset.bottom += 16
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let svc = splitViewController {
            for v in svc.view.subviews {
                if v is CRProductTour {
                    v.removeFromSuperview()
                    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                        appDelegate.shouldRotate = true
                    }
                }
            }
        }
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if let window = UIApplication.sharedApplication().delegate!.window! {
            if window.traitCollection.horizontalSizeClass == .Regular {
                tableView.tableFooterView?.frame.size.height = 0.0
            } else {
                tableView.tableFooterView?.frame.size.height = 80.0
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            var recentSectionCount = 0;
            if let recentFormulas = userDefaults.arrayForKey(StringConstants.RecentFormulas) {
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
            if let recentArray = userDefaults.arrayForKey(StringConstants.RecentFormulas) {
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
            if let recentFormulas = userDefaults.arrayForKey(StringConstants.RecentFormulas) {
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
                    dvc.userDefaults = userDefaults
                }
            }
        }
    }
    
}

extension UISplitViewController {
    
    public override func shouldAutorotate() -> Bool {

        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return appDelegate.shouldRotate
        }
        
        return true
    }
}

