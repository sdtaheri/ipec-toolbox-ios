//
//  ResultsTableViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/28.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {
    
    var inputs = [Double?]()
    private var results = [String: (Double,String,Int)]() {
        didSet {
            if results.count > 0 {
                resultsArrayKeys = results.keys.array
            }
        }
    }
    
    private var resultsArrayKeys = [String]()
    
    var formulaTitle = String() {
        didSet {
            navigationItem.title = formulaTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        switch formulaTitle {
        case "Dew Point Temperature":
            if inputs.count == 3 {
                results = Calculations.dewPointTemperature(inputs[0]!, relativeHumidity: inputs[1]!, airPressure: inputs[2]!)
            }
        default: break
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StringConstants.FormulaCellReuseIdentifier, forIndexPath: indexPath) as! FormulaOutputCell
        
        let resultTitle = resultsArrayKeys[indexPath.row]
        cell.label.text = resultTitle
        
        if let resultValue = results[resultTitle] {
            cell.result.text = "\(resultValue.0)"
            
            if let units = StringConstants.Units[resultValue.1] {
                cell.unit.setTitle(units[resultValue.2], forState: .Normal)
            }
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
