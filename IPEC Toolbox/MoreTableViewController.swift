//
//  MoreTableViewController.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/23.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit
import MessageUI

class MoreTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    private let appURL = "http://itunes.apple.com/app/id1017269434"
    private let reviewURL = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1017269434&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
    
    private var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        default: return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("moreCell", forIndexPath: indexPath)

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: cell.textLabel?.text = "About Us"
            case 1: cell.textLabel?.text = "Contact Us"
            default: break
            }
        case 1:
            cell.textLabel?.text = "Share This App"
        case 2:
            cell.textLabel?.text = "Rate This App"
        default: break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: performSegueWithIdentifier("About Segue", sender: nil)
            case 1: sendEmail()
            default: break
            }
        case 1:
            let url = NSURL(string: appURL)!
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            presentViewController(vc, animated: true, completion: nil)
            
            if selectedIndexPath != nil {
                tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
            }
        case 2:
            let url = NSURL(string: reviewURL)!
            
            if selectedIndexPath != nil {
                tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
            }
            
            UIApplication.sharedApplication().openURL(url)
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var string = ""
        
        switch section {
        case 0:
            string = "We will never send you any spams or ads. Feel free to contact us via email."
        case 1:
            string = "You can share this app with your friends or colleagues so they can enjoy using it as well as you."
        case 2:
            string = "By rating the app in the App Store, you'll give us more energy in order to provide you with a better experience."
        default: break
        }
        
        return string
    }
    
    // MARK: - Helper Methods
    
    func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let deviceModel = DeviceInfo.model()
            let OSVersion = UIDevice.currentDevice().systemVersion
            
            let emailSubject = "IPEC Toolbox Support"
            let messageBody = "<small><p>Please type your comments about this app below this line.</small></p><hr><br><br><br><br><br><br><br><hr><p><small>Device: <b>\(deviceModel)</b><br>iOS Version: <b>\(OSVersion)</b></small></p>"
            let toRecipients = ["toolbox@ipecgroup.net"]
            
            let mc = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailSubject)
            mc.setToRecipients(toRecipients)
            mc.setMessageBody(messageBody, isHTML: true)
            mc.modalPresentationStyle = .PageSheet
            mc.view.tintColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1.0)
            
            presentViewController(mc, animated: true, completion: nil)
        }
        
    }

    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        if selectedIndexPath != nil {
            tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
        }

        dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func dismissAboutController(sender: UIStoryboardSegue) {
        if selectedIndexPath != nil {
            tableView.deselectRowAtIndexPath(selectedIndexPath!, animated: true)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

}
