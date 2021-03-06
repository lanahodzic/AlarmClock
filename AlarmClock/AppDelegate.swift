//
//  AppDelegate.swift
//  AlarmClock
//
//  Created by Lana Hodzic on 1/7/16.
//  Copyright © 2016 CSC484. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var types: UIUserNotificationType = UIUserNotificationType()
        types.insert(UIUserNotificationType.Alert)
        types.insert(UIUserNotificationType.Badge)
        types.insert(UIUserNotificationType.Sound)

        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "Snooze"
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = UIUserNotificationActivationMode.Background
        snoozeAction.authenticationRequired = false
        snoozeAction.destructive = false

        let dismissAction = UIMutableUserNotificationAction()
        dismissAction.identifier = "Dismiss"
        dismissAction.title = "Dismiss"
        dismissAction.activationMode = UIUserNotificationActivationMode.Background
        dismissAction.authenticationRequired = false
        dismissAction.destructive = false

        let actionsArray:[UIUserNotificationAction] = [snoozeAction, dismissAction]
        let alarmCategory = UIMutableUserNotificationCategory()
        alarmCategory.identifier = "alarmCategory"
        alarmCategory.setActions(actionsArray, forContext: UIUserNotificationActionContext.Default)
        alarmCategory.setActions(actionsArray, forContext: UIUserNotificationActionContext.Minimal)
        let categoriesForSettings:Set<UIUserNotificationCategory> = [alarmCategory]

        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categoriesForSettings)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        (getViewController() as! ViewController).openedFromNotification = false
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        (getViewController() as! ViewController).openedFromNotification = false
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (getViewController() as! ViewController).openedFromNotification == true {
            (getViewController() as! ViewController).handleSnoozeNotification()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if application.applicationState == UIApplicationState.Background || application.applicationState == UIApplicationState.Inactive {
            (getViewController() as! ViewController).openedFromNotification = true
        }
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if identifier == "Snooze" {
            NSNotificationCenter.defaultCenter().postNotificationName("snoozeNotification", object: nil)
        }
        else if identifier == "Dismiss" {
            NSNotificationCenter.defaultCenter().postNotificationName("dismissNotification", object: nil)
        }

        completionHandler()
    }


    func getViewController() -> UIViewController? {
        return (self.window?.rootViewController as! UINavigationController).topViewController
    }
}

