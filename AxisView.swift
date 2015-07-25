//
//  BezierView.swift
//  Arduino_Servo
//
//  Created by ben on 14/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class AxisView: UIView {
    
    let context = UIGraphicsGetCurrentContext()
    var cpOne = CGPoint (x: 30,y: 30)
    var cpTwo = CGPoint(x: 270,y: 270)
    var size = CGSize(width:300, height: 300)
    

    override func drawRect(rect: CGRect)
    {
        
        let myColor = UIColor(red: 110/255 , green: 1, blue: 200/255, alpha: 1)
        
        // CONTEXT
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context,UIColor.lightGrayColor().CGColor)
        
        
        //BOX
        CGContextAddRect(context, rect)
        CGContextStrokePath(context)
        
        //BEZIER
        let startPoint = CGPoint(x: 0,y: 0)
        let endPoint = CGPoint(x:size.width, y:size.height)
        let bezierContext = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(bezierContext, 2.0)
        CGContextSetStrokeColorWithColor(bezierContext,myColor.CGColor)
        CGContextMoveToPoint(bezierContext, startPoint.x,startPoint.y)
        CGContextAddCurveToPoint(bezierContext!, cpOne.x,cpOne.y, cpTwo.x,cpTwo.y,endPoint.x,endPoint.y)
        CGContextStrokePath(bezierContext)
    }

    
    
    
    func cubicBezier (positionPoint:CGFloat , start : CGFloat , c1 : CGFloat , c2 : CGFloat , end : CGFloat) ->CGFloat{
        
        let t_ = CGFloat(1.0 - positionPoint)
        let tt_ = CGFloat(t_ * t_)
        let ttt_ = CGFloat (t_ * t_ * t_)
        let tt = CGFloat (positionPoint * positionPoint)
        let ttt = CGFloat(positionPoint * positionPoint * positionPoint)
        
        return start * ttt_ + 3.0 *  c1 * tt_ * positionPoint + c2 * t_ * tt + end * ttt
    }
    

}


