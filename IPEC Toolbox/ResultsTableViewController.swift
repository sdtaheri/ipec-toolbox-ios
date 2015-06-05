//
//  ResultsTableViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/28.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    var inputs = [Double?]()
    private var results = [String: (Double,String,Int)]() {
        didSet {
            if results.count > 0 {
                resultsArrayKeys = results.keys.array
                resultsValue = [Double?](count: results.count, repeatedValue: nil)
                resultsUnits = [String?](count: results.count, repeatedValue: nil)
            }
        }
    }
    
    private var resultsArrayKeys = [String]()
    private var resultsValue = [Double?]()
    private var resultsUnits = [String?]()

    private weak var selectedUnitButton: UIButton?
    
    var formulaTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        
        switch formulaTitle {
        case "Dew Point Temperature":
            results = Calculations.dewPointTemperature(airTemperature: inputs[1]!, relativeHumidity: inputs[2]!, airPressure: inputs[0]!)
        case "Pipeline Submerged Weight":
            let index = Int(inputs[12]!)
            let condition = (MultipleChoiceItems.Dictionary[formulaTitle+"Pipeline Condition"])![index]
            results = Calculations.pipeLineSubmergedWeight(steelPipeOutsideDiameter: inputs[16]!, pipeWallThickness: inputs[11]!, corrosionAllowance: inputs[3]!, corrosionCoatingThickness: inputs[6]!, concreteCoatingThickness: inputs[2]!, marineGrowthThickness: inputs[10]!, steelDensity: inputs[15]!, productDensity: inputs[13]!, corrosionCoatingDensity: inputs[5]!, concreteCoatingDensity: inputs[1]!, seaWaterDensity: inputs[14]!, marineGrowthDensity: inputs[9]!, fieldJointDensity: inputs[7]!, jointLenght: inputs[8]!, corrosionCoatingCutbackLength: inputs[4]!, concreteCoatingCutbackLength: inputs[0]!, pipeLineCondition: condition)
        default: break
        }
    }
    
    @IBAction func showMoreUnits(sender: UIButton) {
            if let cell = sender.superview!.superview as? FormulaOutputCell {
                let resultTitle = cell.label.text!
                if let resultTuple = results[resultTitle] {
                    let unitType = resultTuple.1
                    if let subUnits = StringConstants.Units[unitType] {
                        if subUnits.count > 1 {
                            performSegueWithIdentifier(StringConstants.ShowOutputUnitSegue, sender: sender)
                        }
                    }
                }
            }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        if let utvc = popoverPresentationController.presentedViewController as? UnitsTableViewController {
            let selectedUnit = utvc.selectedUnit
            selectedUnitButton?.setTitle(selectedUnit, forState: .Normal)
            if let contentView = selectedUnitButton?.superview {
                if let cell = contentView.superview as? FormulaOutputCell {
                    if let indexPath = tableView.indexPathForCell(cell) {
                        if let previousValue = resultsValue[indexPath.row], previousUnit = resultsUnits[indexPath.row] {
                            if let resultTuple = results[cell.label.text!] {
                                let unitKind = resultTuple.1
                                if let convertedValue = previousValue.convert(fromUnit: previousUnit , toUnit: selectedUnit , kind: unitKind) {
                                    resultsValue[indexPath.row] = convertedValue
                                    resultsUnits[indexPath.row] = selectedUnit
                                    tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let svc = splitViewController {
            if !svc.collapsed && tableView.backgroundView == nil {
                let imageView = UIImageView(image: UIImage(named: "background")!)
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
                tableView.backgroundView = imageView
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.count > 0 {
            tableView.backgroundView = nil
        }
        return results.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.FormulaCellReuseIdentifier, forIndexPath: indexPath) as! FormulaOutputCell
        
        let resultTitle = resultsArrayKeys[indexPath.row]
        cell.label.text = resultTitle
        
        if let value = resultsValue[indexPath.row], unit = resultsUnits[indexPath.row] {
            cell.result.text = value.doubleToStringWithThounsandSeparator()
            UIView.performWithoutAnimation {
                cell.unit.setTitle(unit, forState: .Normal)
            }
        } else {
            if let resultValue = results[resultTitle] {
                resultsValue[indexPath.row] = resultValue.0
                cell.result.text = resultValue.0.doubleToStringWithThounsandSeparator()
                
                if let units = StringConstants.Units[resultValue.1] {
                    UIView.performWithoutAnimation {
                        cell.unit.setTitle(units[resultValue.2], forState: .Normal)
                        self.resultsUnits[indexPath.row] = units[resultValue.2]
                    }
                }
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formulaTitle + " Calculations"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StringConstants.ShowOutputUnitSegue {
            if let dvc = segue.destinationViewController as? UnitsTableViewController {
                if let button = sender as? UIButton {
                    if let cell = button.superview!.superview as? FormulaOutputCell {
                        let resultTitle = cell.label.text!
                        if let resultTuple = results[resultTitle] {
                            let unitType = resultTuple.1
                            if let units = StringConstants.Units[unitType] {
                                dvc.unitsArray = units
                            }
                        }
                        dvc.selectedUnit = button.currentTitle
                        selectedUnitButton = button
                    }
                }
                
                if let ppc = dvc.popoverPresentationController {
                    ppc.delegate = self
                    ppc.sourceRect = (sender as! UIView).convertRect(sender!.bounds, toView: tableView)
                    
                }
            }
        }
    }
    
}

extension Double {
    func roundToNumberOfDigits(number: Int) -> Double {
        let power = pow(10.0,Double(number))
        return Double(round(power * self)/power)
    }
    
    func doubleToStringWithThounsandSeparator() -> String? {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        formatter.usesGroupingSeparator = true
        return formatter.stringFromNumber(self)
    }

}
