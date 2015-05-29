//
//  FormulaDetail.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/27.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class FormulaDetailTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var headerView: UIImageView! {
        didSet {
            headerView.image = UIImage(named: "\((navigationItem.title)!) 1")
            
            if headerView.image == nil {
                headerView.frame = CGRectZero
            }
        }
    }
    
    private var inputValues = [Double?]()

    private var activeTextField: UITextField?
    
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
        }
        
    }
    
    @IBAction func compute(sender: UIButton) {
        view.endEditing(true)

        var shouldCompute = true
        if inputValues.count == 0 {
            shouldCompute = false
        }
        for i in 0..<inputValues.count {
            if inputValues[i] == nil {
                shouldCompute = false
                break
            }
        }
        if shouldCompute {
            performSegueWithIdentifier(StringConstants.ComputeSegue, sender: nil)
        }
    }
    
    
    @IBAction func showMoreUnits(sender: UIButton) {
        if let titleInputs = StringConstants.Inputs[formulaTitle!] {
            if let cell = sender.superview!.superview as? FormulaInputCell {
                if let unitType = titleInputs[cell.label.text!] {
                    if let subUnits = StringConstants.Units[unitType] {
                        if subUnits.count > 1 {
                            performSegueWithIdentifier(StringConstants.ShowUnitSegue, sender: sender)
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
            if let notificationValue = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
                let keyboardFrame = notificationValue.CGRectValue()
                
                let textFieldRectInWindow = activeTextField!.convertRect(activeTextField!.bounds, toView: nil)
                if textFieldRectInWindow.origin.y + textFieldRectInWindow.size.height >= view.frame.size.height - keyboardFrame.size.height {
                    let textFieldRectInTableView = activeTextField!.convertRect(activeTextField!.bounds, toView: tableView)
                    tableView.setContentOffset(CGPoint(x: 0, y: -keyboardFrame.size.height + textFieldRectInTableView.origin.y + activeTextField!.frame.size.height), animated: true)
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoButton = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        infoButton.addTarget(self, action: "showMoreInfo:", forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if formulaTitle != nil {
            if let inputs = StringConstants.Inputs[formulaTitle!] {
                let inputsArray = inputs.keys.array
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
            let titleInputsArray = titleInputs.keys.array
            
            cell.textField.delegate = self
            
            cell.label.text = titleInputsArray[indexPath.row]
            
            if let unitType = titleInputs[(cell.label.text)!] {
                if let units = StringConstants.Units[unitType] {
                    cell.unitLabel.setTitle(units[0], forState: .Normal)
                }
            } else {
                cell.unitLabel.setTitle("", forState: .Normal)
            }

        } else {
            cell.label.text = ""
            cell.unitLabel.setTitle("", forState: .Normal)
        }
        
        return cell
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StringConstants.ShowUnitSegue {
            if let dvc = segue.destinationViewController as? UnitsTableViewController {
                
                if let titleInputs = StringConstants.Inputs[formulaTitle!] {
                    if let button = sender as? UIButton {
                        if let cell = button.superview!.superview as? FormulaInputCell {
                            if let unitType = titleInputs[cell.label.text!] {
                                if let units = StringConstants.Units[unitType] {
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
                    rtvc.formulaTitle = formulaTitle!
                    rtvc.inputs = inputValues
                }
            }
        }
    }
    
    // MARK: - TextField 
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        if let contentView = textField.superview {
            if let cell = contentView.superview as? FormulaInputCell {
                if let cellRow = tableView.indexPathForCell(cell) {
                    if let doubleValue = textField.text.toDouble() {
                        if inputValues.count != tableView.numberOfRowsInSection(0) {
                            for _ in 0..<tableView.numberOfRowsInSection(0) {
                                inputValues.append(nil)
                            }
                        }
                        inputValues[cellRow.row] = doubleValue
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
    
}

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

