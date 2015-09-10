//
//  AppDelegate.swift
//  IPEC Toolbox
//
//  Created by Saeed Taheri on 2015/5/23.
//  Copyright (c) 2015 Red Cube. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    var shouldRotate = true

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let splitViewController = self.window!.rootViewController as! UISplitViewController
        splitViewController.delegate = self
        
        splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        
        let minimumWidth = min(CGRectGetWidth(splitViewController.view.bounds),CGRectGetHeight(splitViewController.view.bounds));
        splitViewController.minimumPrimaryColumnWidth = minimumWidth / 3;
        splitViewController.maximumPrimaryColumnWidth = minimumWidth;

        
        let orangeColor = UIColor(red: 245/255.0, green: 132/255.0, blue: 31/255.0, alpha: 1.0)
        let grayColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1.0)
        
        UINavigationBar.appearance().barTintColor = orangeColor
        UINavigationBar.appearance().tintColor = grayColor
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor()]

        UITabBar.appearance().tintColor = grayColor
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        
        if splitViewController.collapsed {
            if let master = splitViewController.viewControllers.first as? UITabBarController {
                if let masterNC = master.selectedViewController as? UINavigationController {
                    if vc is UINavigationController {
                        masterNC.pushViewController((vc as! UINavigationController).childViewControllers[0], animated: true)
                    } else {
                        masterNC.pushViewController(vc, animated: true)
                    }
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
        if let master = splitViewController.viewControllers[0] as? UITabBarController {
            if let masterNC = master.selectedViewController as? UINavigationController {
                if let lastController = masterNC.childViewControllers.last as? UINavigationController {
                    if let _ = lastController.childViewControllers[0] as? ResultsTableViewController {
                        return masterNC.popViewControllerAnimated(true)
                    }
                } else if let rtvc = masterNC.childViewControllers.last as? ResultsTableViewController {
                    let nc = UINavigationController(rootViewController: masterNC.popViewControllerAnimated(true)!)
                    rtvc.navigationItem.leftBarButtonItem = nil
                    
                    return nc
                }
            }
        }
        
        return nil
    }

}

