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
    
    var alarms: [String] = ["6:00 AM", "7:30 AM", "8:15 AM", "10:30 AM"]
    var selectedRowIndex = -1
    var isCellTapped = false

    var openedFromNotification: Bool = false
    
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
            notification.fireDate = NSDate().dateByAddingTimeInterval(10)
            notification.alertBody = "Wake up"
            notification.hasAction = true
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.category = "alarmCategory"
            print(notification)
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleSnoozeNotification", name: "snoozeNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDismissNotification", name: "dismissNotification", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // if selectedRowIndex != indexPath.row {
        
        self.alarm_table.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.grayColor()
        let cell = self.alarm_table.cellForRowAtIndexPath(indexPath) as! AlarmCell
        let del = UIButton(frame: CGRect(x: 0, y: 50, width: 100, height: 34))
        del.setTitle("Delete", forState: UIControlState.Normal)
        self.alarm_table.cellForRowAtIndexPath(indexPath)?.addSubview(del)
        
        if selectedRowIndex != -1 {
            self.alarm_table.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedRowIndex, inSection: 0))?.backgroundColor = UIColor.whiteColor()
            del.removeFromSuperview()
        }
            
        if self.selectedRowIndex != indexPath.row {
            self.isCellTapped = true
            self.selectedRowIndex = indexPath.row
        }
        else {
            self.isCellTapped = false
            self.selectedRowIndex = -1
        }
        

        
        //self.selectedRowIndex = indexPath.row
        self.alarm_table.beginUpdates()
        self.alarm_table.endUpdates()
        //   }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex &&  isCellTapped {
            return 140
        }
        
        return alarm_table.rowHeight
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

    func handleSnoozeNotification() {
        print("SNOOZE")
        let notification = UILocalNotification()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.fireDate = NSDate().dateByAddingTimeInterval(10)
        notification.alertBody = "Wake up (snooze)"
        notification.hasAction = true
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "alarmCategory"
        print(notification)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    func handleDismissNotification() {
        print("DISMISS")
    }
}

