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
}

class ViewController: UITableViewController {

    
    @IBOutlet var alarm_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarm_table.numberOfRowsInSection(section)
    }
    
    
    

}

