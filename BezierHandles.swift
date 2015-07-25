//
//  BezierHandles.swift
//  Arduino_Servo
//
//  Created by ben on 15/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class BezierHandles: UIView {

    
    override func drawRect(rect: CGRect) {
        let myColor = UIColor(red: 110/255 , green: 1, blue: 200/255, alpha: 1)
        var path = UIBezierPath(ovalInRect: rect)
        myColor.setFill()
        path.fill()
    }
    

}
