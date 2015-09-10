//
//  FormulaDetail.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/27.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class FormulaDetailTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var resultsTableViewController: ResultsTableViewController?
    
    var userDefaults: NSUserDefaults?
    private var tutorialView: CRProductTour?
    
    private var inputValues = [(Double?,String?)]()
    private var inputValuesForSegue = [Double?]()
    private var inputUnits = [String]()
    private weak var activeTextField: UITextField?
    
    private var dynamicInputValues = [5.0,10.0,10.0]
    
    private weak var selectedUnitButton: UIButton?
    
    var formulaTitle: String? {
        didSet {
            if formulaTitle != nil {
                navigationItem.title = formulaTitle!
            }
        }
    }
    var selectedIndexPath: NSIndexPath? {
        didSet {
            if selectedIndexPath != nil {
                formulaTitle = StringConstants.Titles[selectedIndexPath!.section][selectedIndexPath!.row]
            }
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        switch controller.presentedViewController {
        case _ as UnitsTableViewController: return .None // Keep the popover in Compact screens
        default:
            if traitCollection.horizontalSizeClass == .Regular {
                return .FormSheet
            } else {
                return .OverFullScreen
            }
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        if let utvc = popoverPresentationController.presentedViewController as? UnitsTableViewController {
            let selectedUnit = utvc.selectedUnit
            selectedUnitButton?.setTitle(selectedUnit, forState: .Normal)
            if let contentView = selectedUnitButton?.superview {
                if let cell = contentView.superview as? FormulaInputCell {
                    if let indexPath = tableView.indexPathForCell(cell) {
                        inputUnits[indexPath.row] = selectedUnit
                    }
                }
            }
        }
        
    }
    
    @IBAction func compute(sender: UIButton) {
        view.endEditing(true)
        
        if inputValues.count == 0 {
            return
        }
        
        if dynamicInputValues.reduce(0, combine: +) > 100 {
            let alert = UIAlertController(title: "Error", message: "Sum of percentages exceeds %100", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true) {
                return
            }
        }
        
        for i in 0..<inputValues.count {
            let element = inputValues[i]
            if element.0 == nil || element.1 == nil {
                if formulaTitle != nil {
                    if let inputs = StringConstants.Inputs[formulaTitle!] {
                        let inputsArray = [String](inputs.keys).sort()
                        inputValues[i].0 = (inputs[inputsArray[i]])!.2
                        inputValues[i].1 = (inputs[inputsArray[i]])!.0
                    }
                }
            }
        }
                
        inputValuesForSegue = [Double?](count: inputValues.count, repeatedValue: nil)
        
        for i in 0..<inputValues.count {
            let element = inputValues[i]
            inputValuesForSegue[i] = element.0
            
            if let unitKind = element.1 {
                if unitKind == "Multiple Choice"{
                    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? FormulaInputCellMultipleChoice {
                        inputValuesForSegue[i] = Double(cell.pickerView.selectedRowInComponent(0))
                    }
                } else if unitKind == "Time Picker" {
                    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? FormulaInputCellMultipleChoice {
                        inputValuesForSegue[i] = cell.timePicker.date.timeIntervalSinceReferenceDate
                    }
                } else {
                    inputValuesForSegue[i] = element.0!.convert(fromUnit: inputUnits[i], toUnit: (StringConstants.Units[unitKind])![0], kind: unitKind)!
                }
            }
        }
        
        performSegueWithIdentifier(StringConstants.ComputeSegue, sender: nil)
        
        tableView.reloadData()
    }
    
    
    @IBAction func showMoreUnits(sender: UIButton) {
        if let titleInputs = StringConstants.Inputs[formulaTitle!] {
            if let cell = sender.superview!.superview as? FormulaInputCell {
                if let unitType = titleInputs[cell.label.text!] {
                    if let subUnits = StringConstants.Units[unitType.0] {
                        if subUnits.count > 1 {
                            performSegueWithIdentifier(StringConstants.ShowInputUnitSegue, sender: sender)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        
    }
    
    func showMoreInfo(sender: UIButton) {
        performSegueWithIdentifier(StringConstants.MoreInfo, sender: nil)
    }
    
    @IBAction func dismissMoreInfoController(sender: UIStoryboardSegue) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let notificationValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = notificationValue.CGRectValue()
                
                if keyboardFrame.height != 0 {
                    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height * 1.05, right: 0)
                    tableView.scrollIndicatorInsets = tableView.contentInset
                    
                    let textFieldRectInTableView = activeTextField!.convertRect(activeTextField!.bounds, toView: tableView)
                    tableView.scrollRectToVisible(textFieldRectInTableView, animated: true)
                }
            }
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3) {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height + 8.0, 0)
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.contentInset.bottom += 8.0
        
        let infoButton = UIButton(type: .DetailDisclosure)
        infoButton.addTarget(self, action: "showMoreInfo:", forControlEvents: .TouchUpInside)
        
        let helpButton = UIButton(frame: CGRectMake(0, 0, 22, 22))
        helpButton.setImage(UIImage(named: "help")!, forState: .Normal)
        helpButton.addTarget(self, action: "showHelp:", forControlEvents: .TouchUpInside)

        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: infoButton), UIBarButtonItem(customView: helpButton)]
        
        if let splitVC = self.splitViewController {
            let controllers = splitVC.viewControllers
            if controllers.count > 1 {
                resultsTableViewController = (controllers.last as! UINavigationController).topViewController as? ResultsTableViewController
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
                
        let formulaDetailTutorial = userDefaults?.boolForKey(StringConstants.FormulaDetailTutorial)
        if formulaDetailTutorial == false {
            let button = navigationItem.rightBarButtonItems![1]
            showHelp(button)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        
        if let svc = splitViewController {
            for v in svc.view.subviews {
                if v is CRProductTour {
                    (v as! CRProductTour).setVisible(false)
                }
            }
        }
    }
    
    func showHelp(sender: UIBarButtonItem) {
        
        tableView.contentOffset = CGPointZero
        
        if let svc = splitViewController {
            for v in svc.view.subviews {
                if v is CRProductTour {
                    v.removeFromSuperview()
                    tutorialView = nil
                }
            }
        }
        
        if tableView.visibleCells.count > 1 {
            
            if let firstVisibleRow = tableView.visibleCells[1] as? FormulaInputCell {
                if tutorialView == nil {
                    tutorialView = CRProductTour(frame: view.bounds)
                    
                    let bubble1 = CRBubble(attachedView: firstVisibleRow.textField, title: "Value", description: "Tap to enter data.\nIf ignored, dafault value will be used.", arrowPosition: CRArrowPositionBottom, andColor: view.tintColor)
                    
                    let bubble2 = CRBubble(attachedView: firstVisibleRow.unitLabel, title: "Unit", description: "Tap to choose a different unit.", arrowPosition: CRArrowPositionTop, andColor: view.tintColor)
                    
                    tutorialView!.setBubbles([bubble1, bubble2])
                    
                    tutorialView!.setVisible(false)
                    if let svc = splitViewController {
                        svc.view.addSubview(tutorialView!)
                    }
                }
                
                tutorialView!.setVisible(true)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.shouldRotate = false
                
                userDefaults?.setBool(true, forKey: StringConstants.FormulaDetailTutorial)
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if selectedIndexPath?.section == 1 && selectedIndexPath?.row == 5 {
            return 2
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if formulaTitle != nil {
                if let inputs = StringConstants.Inputs[formulaTitle!] {
                    let inputsArray = [String](inputs.keys)
                    if inputUnits.count == 0 {
                        inputUnits = [String](count: inputsArray.count, repeatedValue: "")
                    }
                    if inputValues.count != inputsArray.count {
                        for _ in 0..<inputsArray.count {
                            inputValues.append((nil,nil))
                        }
                    }
                    return inputsArray.count
                } else {
                    return 0
                }
            } else {
                return 0
            }
        } else if section == 1 {
            return dynamicInputValues.count + 1
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.FormulaCellReuseIdentifier, forIndexPath: indexPath) as! FormulaInputCell
            
            if let titleInputs = StringConstants.Inputs[formulaTitle!] {
                let titleInputsArray = [String](titleInputs.keys).sort()
                cell.label.text = titleInputsArray[indexPath.row]
                
                cell.textField.delegate = self
                
                if inputValues.count == tableView.numberOfRowsInSection(0) {
                    let element = inputValues[indexPath.row]
                    if element.0 != nil {
                        cell.textField.text = "\(element.0!)"
                    } else {
                        cell.textField.text = ""
                    }
                }
                
                if inputUnits[indexPath.row] == "" {
                    if let unitType = titleInputs[(cell.label.text)!] {
                        if let units = StringConstants.Units[unitType.0] {
                            cell.unitLabel.setTitle(units[unitType.1], forState: .Normal)
                            cell.textField.placeholder = "\(unitType.2)"
                            inputUnits[indexPath.row] = units[unitType.1]
                        } else {
                            if unitType.0 == "Multiple Choice" {
                                let newCell = tableView.dequeueReusableCellWithIdentifier(StringConstants.FormulaCellMultipleChoiceResuseIdentifier, forIndexPath: indexPath) as! FormulaInputCellMultipleChoice
                                
                                newCell.label.text = titleInputsArray[indexPath.row]
                                newCell.pickerView.dataSource = self
                                newCell.pickerView.delegate = self
                                
                                return newCell
                            } else if unitType.0 == "Time Picker" {
                                let newCell = tableView.dequeueReusableCellWithIdentifier(StringConstants.FormulaCellTimePickerResuseIdentifier, forIndexPath: indexPath) as! FormulaInputCellMultipleChoice
                                
                                newCell.label.text = titleInputsArray[indexPath.row]
                                
                                return newCell
                            }
                        }
                    } else {
                        cell.unitLabel.setTitle("", forState: .Normal)
                    }
                } else {
                    cell.unitLabel.setTitle(inputUnits[indexPath.row], forState: .Normal)
                    if let unitType = titleInputs[(cell.label.text)!] {
                        cell.textField.placeholder = "\(unitType.2)"
                    }
                }
                
                
            } else {
                cell.label.text = ""
                cell.unitLabel.setTitle("", forState: .Normal)
            }
            return cell
        } else {
            if indexPath.row == tableView.numberOfRowsInSection(indexPath.section) - 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.FormulaCellAddReuseIdentifier, forIndexPath: indexPath) as! FormulaInputCell
                cell.accessoryButton?.tintColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
                
                cell.accessoryButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                cell.accessoryButton.addTarget(self, action: "addRow:", forControlEvents: .TouchUpInside)
                
                cell.label.text = "Add a Pig"
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.FormulaCellDynamicResuseIdentifier, forIndexPath: indexPath) as! FormulaInputCell
                cell.accessoryButton?.tintColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1)
                
                cell.textField.delegate = self
                
                cell.accessoryButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                cell.accessoryButton.addTarget(self, action: "removeRow:", forControlEvents: .TouchUpInside)
                
                cell.label.text = "Length Fraction between Pigs"
                
                let unitType = ("Percentage",0,10)
                if let units = StringConstants.Units[unitType.0] {
                    cell.unitLabel.setTitle(units[unitType.1], forState: .Normal)
                } else {
                    cell.unitLabel.setTitle("", forState: .Normal)
                }
                
                cell.textField.placeholder = "\(dynamicInputValues[indexPath.row])"
                
                return cell
            }
        }
        
    }
    
    func addRow(sender: UIButton) {
        dynamicInputValues.append(5.0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: dynamicInputValues.count - 1, inSection: 1)], withRowAnimation: .Automatic)
    }
    
    func removeRow(sender: UIButton) {
        if dynamicInputValues.count > 1 {
            if let cell = sender.superview?.superview as? FormulaInputCell {
                dynamicInputValues.removeAtIndex(tableView.indexPathForCell(cell)!.row)
                tableView.deleteRowsAtIndexPaths([tableView.indexPathForCell(cell)!], withRowAnimation: .Automatic)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "At least a single row should remain", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.shouldRotate = true
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if tutorialView != nil && tutorialView!.isVisible() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.shouldRotate = true
            
            tutorialView?.setVisible(false)
        }
        
        if segue.identifier == StringConstants.ShowInputUnitSegue {
            if let dvc = segue.destinationViewController as? UnitsTableViewController {
                
                if let titleInputs = StringConstants.Inputs[formulaTitle!] {
                    if let button = sender as? UIButton {
                        if let cell = button.superview!.superview as? FormulaInputCell {
                            if let unitType = titleInputs[cell.label.text!] {
                                if let units = StringConstants.Units[unitType.0] {
                                    dvc.unitsArray = units
                                }
                            }
                            dvc.selectedUnit = button.currentTitle
                            selectedUnitButton = button
                        }
                    }
                }
                
                if let ppc = dvc.popoverPresentationController {
                    ppc.delegate = self
                    ppc.sourceRect = (sender as! UIView).convertRect(sender!.bounds, toView: tableView)
                    
                }
            }
        } else if segue.identifier == StringConstants.ComputeSegue {
            if let nc = segue.destinationViewController as? UINavigationController {
                if let rtvc = nc.childViewControllers[0] as? ResultsTableViewController {
                    rtvc.userDefaults = userDefaults
                    if let window = UIApplication.sharedApplication().keyWindow {
                        if window.traitCollection.horizontalSizeClass == .Compact || window.traitCollection.verticalSizeClass == .Compact {
                            rtvc.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                            rtvc.navigationItem.leftItemsSupplementBackButton = true
                        }
                    }
                    rtvc.formulaTitle = formulaTitle!
                    rtvc.inputs = inputValuesForSegue
                    rtvc.dynamicInputs = dynamicInputValues
                }
            }
        } else if segue.identifier == StringConstants.MoreInfo {
            if let nc = segue.destinationViewController as? UINavigationController {
                nc.presentationController?.delegate = self
                if let rtvc = nc.childViewControllers[0] as? MoreInfoViewController {
                    rtvc.formulaTitle = formulaTitle
                }
            }
        }
    }
    
    // MARK: - TextField
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        
        if tutorialView != nil && tutorialView!.isVisible() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.shouldRotate = true
            
            tutorialView?.setVisible(false)
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        if let contentView = textField.superview {
            if let cell = contentView.superview as? FormulaInputCell {
                if let cellIndexPath = tableView.indexPathForCell(cell) {
                    if cellIndexPath.section == 0 {
                        if let doubleValue = textField.text?.toDouble() {
                            inputValues[cellIndexPath.row].0 = doubleValue
                            
                            if let titleInputs = StringConstants.Inputs[formulaTitle!] {
                                if let unitType = titleInputs[(cell.label.text)!] {
                                    inputValues[cellIndexPath.row].1 = unitType.0
                                }
                            }
                        }
                    } else if cellIndexPath.section == 1 {
                        if let doubleValue = textField.text?.toDouble() {
                            dynamicInputValues[cellIndexPath.row] = doubleValue
                        }
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        compute(UIButton())
        return true
    }
    
    // MARK: - PickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let cell = pickerView.superview?.superview as? FormulaInputCellMultipleChoice {
            if let items = MultipleChoiceItems.Dictionary[formulaTitle! + cell.label.text!] {
                return items.count
            }
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.textAlignment = NSTextAlignment.Center
            label?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            label?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.5
            label?.numberOfLines = 0
        }
        
        if let cell = pickerView.superview?.superview as? FormulaInputCellMultipleChoice {
            if let items = MultipleChoiceItems.Dictionary[formulaTitle! + cell.label.text!] {
                label?.text = items[row]
            }
        }
        
        return label!
    }
}

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}
