//
//  FormulaDetail.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/27.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class FormulaDetailTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var headerView: UIImageView!
    
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
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        if let utvc = popoverPresentationController.presentedViewController as? UnitsTableViewController {
            let selectedUnit = utvc.selectedUnit
            selectedUnitButton?.setTitle(selectedUnit, forState: .Normal)
        }
        
    }
    
    @IBAction func showMoreUnits(sender: UIButton) {
        
        if let titleInputs = StringConstants.Inputs[formulaTitle!] {
            if let cell = sender.superview!.superview as? FormulaInputCell {
                if titleInputs[cell.label.text!]?.count > 1 {
                    performSegueWithIdentifier(StringConstants.ShowUnitSegue, sender: sender)
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if self.navigationItem.title == "Dew Point Temperature" {
            headerView.image = UIImage(named: "dewPoint")
        }
        
        if headerView.image == nil {
            headerView.frame = CGRectZero
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
            
            cell.label.text = titleInputsArray[indexPath.row]
            
            if let units = titleInputs[(cell.label.text)!] {
                cell.unitLabel.setTitle(units[0], forState: .Normal)
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
                            dvc.unitsArray = titleInputs[cell.label.text!]
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
        }
    }
    
    

}
