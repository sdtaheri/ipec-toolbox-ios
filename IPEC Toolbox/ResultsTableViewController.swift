//
//  ResultsTableViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/28.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var headerView: UIImageView! {
        didSet {
            headerView.image = UIImage(named: "\(formulaTitle) 1")
            
            if headerView.image == nil {
                headerView.frame = CGRectZero
            }
        }
    }
    
    var inputs = [Double?]()
    var userDefaults: NSUserDefaults?
    private var tutorialView: CRProductTour?
    private var results = [String: (Double,String,Int)]() {
        didSet {
            if results.count > 0 {
                resultsArrayKeys = results.keys.array.sorted {
                    return $0 < $1
                }
                resultsValue = [Double?](count: results.count, repeatedValue: nil)
                resultsUnits = [String?](count: results.count, repeatedValue: nil)
            }
        }
    }
    
    private var resultsArrayKeys = [String]()
    private var resultsValue = [Double?]()
    private var resultsUnits = [String?]()
    
    var documentInteractionController: UIDocumentInteractionController?

    private weak var selectedUnitButton: UIButton?
    
    var formulaTitle = String()
    
    private var footerOnScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        shareButton.enabled = false
        
//        let helpButton = UIBarButtonItem(title: "Help", style: .Plain, target: self, action: "showHelp")
//        helpButton.enabled = false
//        navigationItem.rightBarButtonItems?.append(helpButton)
        
        switch formulaTitle {
            
        case "Maximum Allowable Working Pressure":
            let index = Int(inputs[0]!)
            let condition = (MultipleChoiceItems.Dictionary[formulaTitle+"Joint Efficiency"])![index]
            results = Calculations.maximumAllowableWorkingPressure(jointEfficiency: condition, pipelineOutsideDiameter: inputs[1]!, pipelineWallThickness: inputs[2]!, yieldStress: inputs[3]!)
            
        case "Pipeline Submerged Weight":
            let index = Int(inputs[12]!)
            let condition = (MultipleChoiceItems.Dictionary[formulaTitle+"Pipeline Condition"])![index]
            results = Calculations.pipeLineSubmergedWeight(steelPipeOutsideDiameter: inputs[16]!, pipeWallThickness: inputs[11]!, corrosionAllowance: inputs[3]!, corrosionCoatingThickness: inputs[6]!, concreteCoatingThickness: inputs[2]!, marineGrowthThickness: inputs[10]!, steelDensity: inputs[15]!, productDensity: inputs[13]!, corrosionCoatingDensity: inputs[5]!, concreteCoatingDensity: inputs[1]!, seaWaterDensity: inputs[14]!, marineGrowthDensity: inputs[9]!, fieldJointDensity: inputs[7]!, jointLenght: inputs[8]!, corrosionCoatingCutbackLength: inputs[4]!, concreteCoatingCutbackLength: inputs[0]!, pipeLineCondition: condition)
            
        case "Temperature Drop Across Pipe Wall":
            results = Calculations.temperatureDropAcrossPipewall(ambientFluidDensity: inputs[0]!, ambientFluidHeatCapacity: inputs[1]!, ambientFluidThermalConductivity: inputs[2]!, ambientFluidVelocity: inputs[3]!, ambientFluidViscosity: inputs[4]!, ambientTemperature: inputs[5]!, coatingThermalConductivity: inputs[6]!, coatingThickness: inputs[7]!, concreteThermalConductivity: inputs[8]!, concreteThickness: inputs[9]!, fluidTemperature: inputs[10]!, internalFluidDensity: inputs[11]!, internalFluidHeatCapacity: inputs[12]!, internalFluidThermalConductivity: inputs[13]!, internalFluidViscosity: inputs[14]!, internalFluidVolumetricFlowRate: inputs[15]!, nominalOuterDiameter: inputs[16]!, pipewallThickness: inputs[17]!, pipelineBuriedHeight: inputs[18]!, pipelineThermalConductivity: inputs[19]!, soilThermalConductivity: inputs[20]!)
            
        case "Pipe Wall Thickness":
            
            let locationClass = MultipleChoiceItems.Dictionary[formulaTitle+"Location Class (For Human Occupancy)"]![Int(inputs[0]!)]
            let productionType = MultipleChoiceItems.Dictionary[formulaTitle+"Pipeline Production"]![Int(inputs[3]!)]
            results = Calculations.pipeWallThickness(locationClass: locationClass, pipelineDesignPressure: inputs[1]!, pipelineOutsideDiameter: inputs[2]!, pipelineProduction: productionType, specifiedMinimumYieldStress: inputs[4]!)
            
        case "Pressure Drop for Fluid Flow in Pipelines":
            results = Calculations.pressureDropForFluidFlowInPipelines(fluidDensity: inputs[0]!, fluidDynamicViscosity: inputs[1]!, pipelineInletElevation: inputs[2]!, pipelineLength: inputs[3]!, pipelineOutletElevation: inputs[4]!, pipelineOutsideDiameter: inputs[5]!, pipelineWallThickness: inputs[6]!, surfaceRoughness: inputs[7]!, volumetricFlowRate: inputs[8]!)
            
        case "Chemical Dosing for Water Treatment":
            results = Calculations.chemicalDosingForWaterTreatment(chemicalDosage: inputs[0]!, volumetricFlowRate: inputs[1]!)
            
        case "Pipeline Internal Volume":
            results = Calculations.pipelineInternalVolume(pipelineLength: inputs[0]!, pipelineOutsideDiameter: inputs[1]!, pipelineWallThickness: inputs[2]!)
            
        case "Dew Point Temperature":
            results = Calculations.dewPointTemperature(airTemperature: inputs[1]!, relativeHumidity: inputs[2]!, airPressure: inputs[0]!)

        case "Mean Flow Velocity":
            results = Calculations.meanFlowVelocity(pipelineOutsideDiameter: inputs[0]!, pipelineWallThickness: inputs[1]!, volumetricFlowRate: inputs[2]!)

            
        default: break
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !formulaTitle.isEmpty {
            shareButton.enabled = true
//            (navigationItem.rightBarButtonItems?.last! as! UIBarButtonItem).enabled = true
        }
        
        let formulaDetailTutorial = userDefaults?.boolForKey(StringConstants.ResultsTutorial)
        if formulaDetailTutorial == false {
            showHelp()
        }
    }
    
    func showHelp() {
        
        if let svc = splitViewController {
            for v in svc.view.subviews {
                if v is CRProductTour {
                    v.removeFromSuperview()
                    tutorialView = nil
                }
            }
        }

        if tableView.visibleCells().count > 0 {
            
            if let firstVisibleRow = tableView.visibleCells()[0] as? FormulaOutputCell {
                if tutorialView == nil {
                    tutorialView = CRProductTour(frame: view.bounds)
                    
                    let bubble1 = CRBubble(attachedView: firstVisibleRow.unit, title: "Unit", description: "Tap to convert to a different unit.", arrowPosition: CRArrowPositionTop, andColor: view.tintColor)
                    
                    tutorialView!.setBubbles([bubble1])
                    
                    tutorialView!.setVisible(false)
                    if let svc = splitViewController {
                        svc.view.addSubview(tutorialView!)
                    }
                }
                
                tutorialView!.setVisible(true)
                if let svc = splitViewController {
                    svc.view.bringSubviewToFront(tutorialView!)
                }
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.shouldRotate = false
                
                userDefaults?.setBool(true, forKey: StringConstants.ResultsTutorial)
            }
        }

    }
    
    @IBAction func shareResults(sender: UIBarButtonItem) {
    
        let fileName = "Results.pdf"
        let arrayPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        let path = arrayPaths[0]
        let pdfFileName = path.stringByAppendingPathComponent(fileName)

        PDFRenderer.drawPDF(pdfFileName, title: formulaTitle, labels: resultsArrayKeys, results: results)
        
        let fileMgr = NSFileManager.defaultManager()
        if fileMgr.fileExistsAtPath(pdfFileName) {
            
            documentInteractionController = UIDocumentInteractionController(URL: NSURL(fileURLWithPath: pdfFileName)!)
            documentInteractionController!.presentOptionsMenuFromBarButtonItem(sender, animated: true)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if tutorialView != nil && tutorialView!.isVisible() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.shouldRotate = true
            
            tutorialView?.setVisible(false)
        }
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if let window = UIApplication.sharedApplication().delegate!.window! {
            if window.traitCollection.horizontalSizeClass == .Regular && results.count == 0 {
                
                if let superView = view.superview {
                    for v in superView.subviews {
                        if v is UIImageView {
                            return
                        }
                    }
                    let image = UIImage(named: "logo")!
                    let aspectRatio = image.size.width / image.size.height
                    
                    let imageView = UIImageView(image: image)
                    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
                    superView.addSubview(imageView)
                    
                    superView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: superView, attribute: .Bottom, multiplier: 1.0, constant: -8.0))
                    superView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: superView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
                    superView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: superView, attribute: .Width, multiplier: 0.3, constant: 0.0))
                    superView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: imageView, attribute: .Height, multiplier: aspectRatio, constant: 0.0))

                }
            }
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
            cell.result.text = value.doubleToStringWithThousandSeparator()
            UIView.performWithoutAnimation {
                cell.unit.setTitle(unit, forState: .Normal)
            }
        } else {
            if let resultValue = results[resultTitle] {
                resultsValue[indexPath.row] = resultValue.0
                cell.result.text = resultValue.0.doubleToStringWithThousandSeparator()
                
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
        if inputs.count == 0 {
            navigationItem.title = nil
            return nil
        }
        return formulaTitle + " Calculations"
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if inputs.count == 0 {
            return nil
        }
        
        switch formulaTitle {
        case "Pipeline Submerged Weight":
            return "For onshore pipelines, the submerged weight is of no use; only dry weight must be used. \n\nFor calculating weight of an empty pipeline, use zero density for the fluid density."
            
        case "Maximum Allowable Working Pressure":
            return "The “Joint Efficiency” must be selected from the Weld Types tabled provided herein. \n\nAll calculations are in accordance with ASME, Section VIII, Division 1."
            
        case "Temperature Drop Across Pipe Wall":
            return "Heat Transfer is assumed one-dimensional and heat flux along the pipe wall is neglected."
            
        case "Pipe Wall Thickness":
            return "The pipe wall thickness is calculated based on ASME B31.8 and ASME B31.4."
            
        case "Pressure Drop for Fluid Flow in Pipelines":
            return "The friction coefficient is calculated using the so-called implicit Colebrook equation. \n\nFor non-circular pipelines, the equivalent hydraulic diameter must be used. \n\nOnly the difference between pipeline inlet and outlet is used in the calculations. \n\nSince the viscosity is a function of fluid temperature, reference tables should be checked for an accurate calculation. \n\nMinor head losses are not calculated and included in the reported total head loss."
            
        case "Chemical Dosing for Water Treatment":
            return "The most common way of describing dosage (ppm) is used in this calculation. \n\nThis calculation is useful when performing water treatment for pipeline operations such as filling, flooding, cleaning etc."
            
        case "Pipeline Internal Volume":
            return "This module can only calculate the internal volume of circular pipelines."
            
        case "Dew Point Temperature":
            return "This calculation is more accurate when the ambient temperature is between -45 and 60 °C. \n\nThe dew point temperature is obtained from the well-known Arden Buck equation."
            
        case "Mean Flow Velocity":
            return "The internal area of the pipeline is calculated without considering the pipe roughness. \n\nIt is assumed the fluid is in a single phase, either liquid or gas."

        default: return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if tutorialView != nil && tutorialView!.isVisible() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.shouldRotate = true
            
            tutorialView?.setVisible(false)
        }
        
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
    
    func doubleToStringWithThousandSeparator() -> String? {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        formatter.usesGroupingSeparator = true
        return formatter.stringFromNumber(self)
    }

}
