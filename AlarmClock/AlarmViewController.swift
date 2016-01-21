//
//  AlarmViewController.swift
//  AlarmClock
//
//  Created by Lana Hodzic on 1/20/16.
//  Copyright © 2016 CSC484. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var timePicker: UIPickerView!
    
    let hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timePicker.dataSource = self
        self.timePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveAlarm(sender: AnyObject) {
        let ndx = timePicker.selectedRowInComponent(0)
        let diff = hours[ndx]
        var time_day = "AM"
        var time = ctime()
        print("\(time.h)")
        if time.h > 12 {
            time.h -= 12
        }
        
        time.h += diff
        
        if time.h > 12 {
            time.h -= 12
            time_day = "PM"
        }
        
        print("\(time.h)")
        
        let viewcontrollers = self.navigationController!.viewControllers
        let controller = viewcontrollers[0] as! ViewController
        controller.alarms.append("\(time.h):\(time.m) \(time_day)")
        controller.alarm_table!.reloadData()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    func ctime ()->(h:Int,m:Int,s:Int) {
        
        var t = time_t()
        time(&t)
        let x = localtime(&t) // returns UnsafeMutablePointer
        
        return (h:Int(x.memory.tm_hour),m:Int(x.memory.tm_min),s:Int(x.memory.tm_sec))
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hours.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(hours[row])"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
