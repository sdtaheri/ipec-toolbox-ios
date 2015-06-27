//
//  FormulaDetail.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/27.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class FormulaDetailTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var resultsTableViewController: ResultsTableViewController?
    
    @IBOutlet weak var headerView: UIImageView! {
        didSet {
            headerView.image = UIImage(named: "\((navigationItem.title)!) 1")
            
            if headerView.image == nil {
                headerView.frame = CGRectZero
            }
        }
    }
    
    private var previousContentInset = UIEdgeInsetsZero
    
    var userDefaults: NSUserDefaults?
    private var tutorialView: CRProductTour?
    
    private var inputValues = [Double?,String?]()
    private var inputValuesForSegue = [Double?]()
    private var inputUnits = [String]()
    private weak var activeTextField: UITextField?
    
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
                if selectedIndexPath!.section != 2 {
                    formulaTitle = StringConstants.Titles[selectedIndexPath!.section][selectedIndexPath!.row]
                } else {
                    
                }
            }
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        switch controller.presentedViewController {
        case let vc as UnitsTableViewController: return .None // Keep the popover in Compact screens
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
        
        var inputValuesMirror = reflect(inputValues)
        
        for i in 0..<inputValues.count {
            let (_, mirror) = inputValuesMirror[i]
            let element = mirror.value as! (Double?,String?)
            if element.0 == nil || element.1 == nil {
                if formulaTitle != nil {
                    if let inputs = StringConstants.Inputs[formulaTitle!] {
                        let inputsArray = inputs.keys.array.sorted {
                            return $0 < $1
                        }
                        inputValues[i].0 = (inputs[inputsArray[i]])!.2
                        inputValues[i].1 = (inputs[inputsArray[i]])!.0
                    }
                }
            }
        }
        
        inputValuesMirror = reflect(inputValues)
        
        inputValuesForSegue = [Double?](count: inputValues.count, repeatedValue: nil)
        
        for i in 0..<inputValues.count {
            let (_, mirror) = inputValuesMirror[i]
            let element = mirror.value as! (Double?, String?)
            inputValuesForSegue[i] = element.0
            
            if let unitKind = element.1 {
                if unitKind != "Multiple Choice" {
                    inputValuesForSegue[i] = element.0!.convert(fromUnit: inputUnits[i], toUnit: (StringConstants.Units[unitKind])![0], kind: unitKind)!
                } else {
                    if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? FormulaInputCellMultipleChoice {
                        inputValuesForSegue[i] = Double(cell.pickerView.selectedRowInComponent(0))
                    }
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
                
                let textFieldRectInWindow = activeTextField!.convertRect(activeTextField!.bounds, toView: nil)
                if textFieldRectInWindow.origin.y + textFieldRectInWindow.size.height >= UIScreen.mainScreen().bounds.size.height - keyboardFrame.size.height {

                    previousContentInset = tableView.contentInset
                    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height * 1.05, right: 0)
                    tableView.scrollIndicatorInsets = tableView.contentInset
                    
                    let textFieldRectInTableView = activeTextField!.convertRect(activeTextField!.bounds, toView: tableView)
                    tableView.scrollRectToVisible(textFieldRectInTableView, animated: true)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3) {
            self.tableView.contentInset = self.previousContentInset
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        
        let infoButton = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        infoButton.addTarget(self, action: "showMoreInfo:", forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        if let splitVC = self.splitViewController {
            let controllers = splitVC.viewControllers
            self.resultsTableViewController = controllers[controllers.count-1].topViewController as? ResultsTableViewController
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let svc = splitViewController {
            for v in svc.view.subviews {
                if v is CRProductTour {
                    v.removeFromSuperview()
                }
            }
        }
        
        let formulaDetailTutorial = userDefaults?.boolForKey(StringConstants.FormulaDetailTutorial)
        
        if formulaDetailTutorial == false {
            if tableView.visibleCells().count > 1 {
                
                if let firstVisibleRow = tableView.visibleCells()[1] as? FormulaInputCell {
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
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        if let svc = splitViewController {
            for v in svc.view.subviews {
                if v is CRProductTour {
                    v.setVisible(false)
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if formulaTitle != nil {
            if let inputs = StringConstants.Inputs[formulaTitle!] {
                let inputsArray = inputs.keys.array
                if inputUnits.count == 0 {
                    inputUnits = [String](count: inputsArray.count, repeatedValue: "")
                }
                if inputValues.count != inputsArray.count {
                    for _ in 0..<inputsArray.count {
                        inputValues.append(nil,nil)
                    }
                }
                return inputsArray.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.FormulaCellReuseIdentifier, forIndexPath: indexPath) as! FormulaInputCell
        
        if let titleInputs = StringConstants.Inputs[formulaTitle!] {
            let titleInputsArray = titleInputs.keys.array.sorted {
                return $0 < $1
            }
            
            cell.label.text = titleInputsArray[indexPath.row]
            
            cell.textField.delegate = self
            
            if inputValues.count == tableView.numberOfRowsInSection(0) {
                let inputValuesMirror = reflect(inputValues)
                
                let (_,mirror) = inputValuesMirror[indexPath.row]
                let element = mirror.value as! (Double?,String?)
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
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if tutorialView != nil && tutorialView!.isVisible() {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.shouldRotate = true
            
            tutorialView?.setVisible(false)
        }
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
                    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                        rtvc.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                        rtvc.navigationItem.leftItemsSupplementBackButton = true
                    }
                    rtvc.formulaTitle = formulaTitle!
                    rtvc.inputs = inputValuesForSegue
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
                    if let cellRow = tableView.indexPathForCell(cell) {
                        if let doubleValue = textField.text.toDouble() {
                            inputValues[cellRow.row].0 = doubleValue
                            
                            if let titleInputs = StringConstants.Inputs[formulaTitle!] {
                                if let unitType = titleInputs[(cell.label.text)!] {
                                    inputValues[cellRow.row].1 = unitType.0
                                }
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
        
        func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
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
