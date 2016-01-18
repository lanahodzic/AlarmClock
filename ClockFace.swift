//
//  ClockFace.swift
//  AlarmClock
//
//  Created by Lana Hodzic on 1/10/16.
//  Copyright © 2016 CSC484. All rights reserved.
//

import UIKit

class ClockFace: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let radius = CGRectGetWidth(rect) / 3.5
        
        let endAngle = CGFloat(2 * M_PI)
        
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), radius, 0, endAngle, 1)
        CGContextSetFillColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 4.0)
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
        
        for i in 1...60 {
            CGContextSaveGState(context)
            CGContextTranslateCTM(context, CGRectGetMidX(rect), CGRectGetMidY(rect))
            CGContextRotateCTM(context, degreeToRadian(CGFloat(i) * 6))
            
            if i % 5 == 0 {
                drawSecondMarker(context!, x: radius-15, y: 0, radius: radius, color: UIColor.whiteColor())
            }
            else {
                drawSecondMarker(context!, x: radius-10, y: 0, radius: radius, color: UIColor.whiteColor())
            }
            
            CGContextRestoreGState(context)
        }
        
        drawText(rect, context: context!, x:CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: radius, sides: 12, color: UIColor.whiteColor())
    }
}

    func degreeToRadian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a / 180
        return b
    }

    func drawSecondMarker(context:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, color:UIColor) {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, radius, 0)
        CGPathAddLineToPoint(path, nil, x, y)
        CGPathCloseSubpath(path)
        CGContextAddPath(context, path)
        CGContextSetLineWidth(context, 1.5)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextStrokePath(context)
    }
    
    func circleCircumferencePoints(sides:Int, x:CGFloat, y: CGFloat, radius:CGFloat, adjustment:CGFloat=0)->[CGPoint] {
        let angle = degreeToRadian(360 / CGFloat(sides))
        let cx = x
        let cy = y
        let r = radius
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i) + degreeToRadian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i) + degreeToRadian(adjustment))
            points.append(CGPoint(x:xpo, y:ypo))
            i--
        }
        return points
    }
    
    func secondMarkers(context:CGContextRef, x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, color:UIColor) {
        let points = circleCircumferencePoints(sides, x: x, y: y, radius: radius)
        let path = CGPathCreateMutable()
        var divider:CGFloat = 1/16
        for p in points.enumerate() {
            if p.index % 5 == 0 {
                divider = 1/8
            }
            else {
                divider = 1/16
            }
            
            let xn = p.element.x + divider * (x - p.element.x)
            let yn = p.element.y + divider * (y - p.element.y)
            CGPathMoveToPoint(path, nil, p.element.x, p.element.y)
            CGPathAddLineToPoint(path, nil, xn, yn)
            CGPathCloseSubpath(path)
            CGContextAddPath(context, path)
        }
        
        let cgcolor = color.CGColor
        CGContextSetStrokeColorWithColor(context, cgcolor)
        CGContextSetLineWidth(context, 3.0)
        CGContextStrokePath(context)
    }
    
    func drawText(rect: CGRect, context:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
        CGContextTranslateCTM(context, 0.0, CGRectGetHeight(rect))
        CGContextScaleCTM(context, 1.0, -1.0)
        
        let inset:CGFloat = radius / 3.5
        let points = circleCircumferencePoints(sides, x: x, y: y, radius: radius - inset, adjustment: 270)
        let path = CGPathCreateMutable()
        
        for p in points.enumerate() {
            if p.index > 0 {
                let aFont = UIFont(name: "Optima-Bold", size: radius/5)
                let attr:CFDictionaryRef = [NSFontAttributeName:aFont!, NSForegroundColorAttributeName: UIColor.whiteColor()]
                let text = CFAttributedStringCreate(nil, p.index.description, attr)
                let line = CTLineCreateWithAttributedString(text)
                let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
                CGContextSetLineWidth(context, 1.5)
                
                let xn = p.element.x - bounds.width/2
                let yn = p.element.y - bounds.midY
                
                CGContextSetTextDrawingMode(context, CGTextDrawingMode.Stroke)
                CGContextSetTextPosition(context, xn, yn)
                CTLineDraw(line, context)
            }
        }
    }
    
