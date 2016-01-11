//
//  ClockViewController.swift
//  AlarmClock
//
//  Created by Lana Hodzic on 1/10/16.
//  Copyright © 2016 CSC484. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {

    var i = 0
    var clockView:ClockFace?
    var hourLayer:CAShapeLayer?
    var minuteLayer:CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clockView = ClockFace(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        clockView!.userInteractionEnabled = true;
        self.view.addSubview(clockView!)
        
        let time = timeCoords(CGRectGetMidX(clockView!.frame), y: CGRectGetMidY(clockView!.frame), time: ctime(), radius: 50)
        hourLayer = CAShapeLayer()
        hourLayer!.frame = clockView!.frame
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, CGRectGetMidX(clockView!.frame), CGRectGetMidY(clockView!.frame))
        CGPathAddLineToPoint(path, nil, time.h.x, time.h.y)
        hourLayer!.path = path
        hourLayer!.lineWidth = 4
        hourLayer!.lineCap = kCALineCapSquare
        hourLayer!.strokeColor = UIColor.redColor().CGColor
        hourLayer!.rasterizationScale = UIScreen.mainScreen().scale
        hourLayer!.shouldRasterize = true
        self.view.layer.addSublayer(hourLayer!)
        
        minuteLayer = CAShapeLayer()
        minuteLayer!.frame = clockView!.frame
        let minutePath = CGPathCreateMutable()
        
        CGPathMoveToPoint(minutePath, nil, CGRectGetMidX(clockView!.frame), CGRectGetMidY(clockView!.frame))
        CGPathAddLineToPoint(minutePath, nil, time.m.x, time.m.y)
        minuteLayer!.path = minutePath
        minuteLayer!.lineWidth = 3
        minuteLayer!.lineCap = kCALineCapSquare
        minuteLayer!.strokeColor = UIColor.redColor().CGColor
        minuteLayer!.rasterizationScale = UIScreen.mainScreen().scale
        minuteLayer!.shouldRasterize = true
        self.view.layer.addSublayer(minuteLayer!)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInView(self.view)
        if i % 2 == 0 {
            //TODO make sure the hour hand is shorter than the minute hand
           let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, CGRectGetMidX(self.clockView!.frame), CGRectGetMidY(self.clockView!.frame))
            CGPathAddLineToPoint(path, nil, location.x, location.y)
            hourLayer!.frame = clockView!.frame
            hourLayer!.path = path
            hourLayer!.lineWidth = 4
            hourLayer!.lineCap = kCALineCapSquare
            hourLayer!.strokeColor = UIColor.redColor().CGColor
            hourLayer!.rasterizationScale = UIScreen.mainScreen().scale
            hourLayer!.shouldRasterize = true
        }
        else {
            //TODO make sure that the minute hand is longer than the hour hand
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, CGRectGetMidX(self.clockView!.frame), CGRectGetMidY(self.clockView!.frame))
            CGPathAddLineToPoint(path, nil, location.x, location.y)
            minuteLayer!.frame = clockView!.frame
            minuteLayer!.path = path
            minuteLayer!.lineWidth = 3
            minuteLayer!.lineCap = kCALineCapSquare
            minuteLayer!.strokeColor = UIColor.redColor().CGColor
            minuteLayer!.rasterizationScale = UIScreen.mainScreen().scale
            minuteLayer!.shouldRasterize = true

        }
        i++
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ctime ()->(h:Int,m:Int,s:Int) {
        
        var t = time_t()
        time(&t)
        let x = localtime(&t) // returns UnsafeMutablePointer
        
        return (h:Int(x.memory.tm_hour),m:Int(x.memory.tm_min),s:Int(x.memory.tm_sec))
    }
    // END: Retrieve time
    
    // MARK: Calculate coordinates of time
    func  timeCoords(x:CGFloat,y:CGFloat,time:(h:Int,m:Int,s:Int),radius:CGFloat,adjustment:CGFloat=90)->(h:CGPoint, m:CGPoint,s:CGPoint) {
        let cx = x // x origin
        let cy = y // y origin
        var r  = radius // radius of circle
        var points = [CGPoint]()
        var angle = degreeToRadian(6)
        func newPoint (t:Int) {
            let xpo = cx - r * cos(angle * CGFloat(t)+degreeToRadian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(t)+degreeToRadian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
        }
        // work out hours first
        var hours = time.h
        if hours > 12 {
            hours = hours-12
        }
        let hoursInSeconds = time.h*3600 + time.m*60 + time.s
        newPoint(hoursInSeconds*5/3600)
        
        // work out minutes second
        r = radius * 1.25
        let minutesInSeconds = time.m*60 + time.s
        newPoint(minutesInSeconds/60)
        
        // work out seconds last
        r = radius * 1.5
        newPoint(time.s)
        
        return (h:points[0],m:points[1],s:points[2])
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
