//
//  dotPreview.swift
//  Arduino_Servo
//
//  Created by ben on 16/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class DotPreview: UIView {
    
    var intervalPoint : CGFloat = 0
    var positionArray : Array<Float> = []
    var bezierArray : Array<CGFloat> {
        get{
            return makePointArray(positionArray)
        }
    }
    
    func makePointArray(myArray : [Float]) -> Array<CGFloat>{
        var pointArray : [CGFloat] = []
        
        for (var index = 0 ; index < myArray.count ; index++){
            
            let spacePoint :  CGFloat = 0.0
            var stepPoint  :Float = 0
            if index == 0{
                stepPoint = 0
            }
            else if index == myArray.count{
                stepPoint = 0
            }
            else{
                stepPoint = (myArray[index ]) - (myArray[index-1])
            }
            
            let pointCG = CGFloat (stepPoint)
            pointArray.append(spacePoint)
            pointArray.append(intervalPoint)
            self.setNeedsDisplay()
            
        }
        return pointArray
    }


    override func drawRect(rect: CGRect) {
        let dotContext = UIGraphicsGetCurrentContext()
        let myColor = UIColor(red: 110/255 , green: 1, blue: 200/255, alpha: 1)
        let path = UIBezierPath()
        CGContextSetStrokeColorWithColor(dotContext,myColor.CGColor)
        path.moveToPoint(CGPointMake(0, 10))
        path.addLineToPoint(CGPointMake(300, 10))
        path.lineWidth = 3
        let dashes: [CGFloat] = [ path.lineWidth * 0, path.lineWidth * 2 ]
        path.setLineDash(bezierArray, count: bezierArray.count, phase: 0)
        path.lineCapStyle = kCGLineCapRound
        
        path.stroke()
        
        self.setNeedsDisplay()
    }
    
    

}
