//
//  ViewController.swift
//  AlarmClock
//
//  Created by Lana Hodzic on 1/7/16.
//  Copyright © 2016 CSC484. All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var state: UISwitch!
    var alarmSet:Bool?
}

class ViewController: UITableViewController {

    var alarms: [String] = ["6:00 AM", "7:30 AM", "8:15 AM", "11:18"]
    
    @IBOutlet var alarm_table: UITableView!
    
    @IBAction func SetAlarm(sender: AnyObject) {
        let alarm_switch = sender as! UISwitch
        alarm_switch.addTarget(self, action: "toggleAlarm", forControlEvents: UIControlEvents.ValueChanged)
        let cell = alarm_switch.superview!.superview as! AlarmCell
        cell.alarmSet = alarm_switch.selected

        if alarm_switch.on {
            let timeComponents = cell.time.text?.componentsSeparatedByString(":")
            let notification = UILocalNotification()
            notification.timeZone = NSTimeZone.defaultTimeZone()
            let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let alarmDate = gregorian?.nextDateAfterDate(NSDate(), matchingHour: Int(timeComponents![0])!, minute: Int(timeComponents![1])!, second: 0, options: NSCalendarOptions.MatchNextTime)
            notification.fireDate = alarmDate
//            notification.fireDate = NSDate().dateByAddingTimeInterval(5)
            notification.alertBody = "Wake up"
            notification.hasAction = true
            notification.soundName = UILocalNotificationDefaultSoundName
            print(notification)
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmCell
        // Configure the cell...
        let alarm = alarms[indexPath.row]
        cell.time.text = alarm
        cell.state.tag = indexPath.row
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }

}

