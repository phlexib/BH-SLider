//
//  BezierViewController.swift
//  Arduino_Servo
//
//  Created by ben on 14/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class BezierViewController: UIViewController {
    let transitionManager = TransitionManager()

    @IBOutlet weak var bezierFrame: AxisView!
    @IBOutlet weak var cpTwoView: UIView!
    @IBOutlet weak var cpOneView: UIView!
    @IBOutlet weak var labelPassed: UILabel!
    
    var labelText = String()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        labelPassed.text = labelText
        
//        cpOneView.center = CGPoint(x: 0,y: 0)
//        cpTwoView.center = CGPoint(x: 0,y: 0)
        
        var invertScale = CGAffineTransformMakeScale(1, -1)
        bezierFrame.transform = invertScale
        
        UIView.animateWithDuration(2, delay: 2, options: nil, animations: {
            self.bezierFrame.frame = CGRect(x: 320-50, y: 120, width: 50, height: 50)
            //self.bezierFrame.backgroundColor = UIColor.redColor()
            }, completion: { finished in
                // any code entered here will be applied
                // once the animation has completed
                
        })

       
        // Do any additional setup after loading the view.
    }

//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        if let touch = touches.first as? UITouch {
//         
//        }
//        super.touchesBegan(touches , withEvent:event)
//    }
//    
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        if let touch = touches.first as? UITouch {
//            
//            var pointLocation = touch.locationInView(bezierFrame)
//            
//            if cpOneView.pointInside(pointLocation, withEvent: event){
//                cpOneView.frame.origin = pointLocation
//                println(pointLocation)
//            }
//            
//        }
//        super.touchesBegan(touches , withEvent:event)
//
//    }
//    
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        
//    }
    
    @IBAction func menuButton(sender: UIButton) {
        
    }
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(bezierFrame)
        
        
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
            
            if view.center.x <= 0{
                view.center.x = 0
            }
            
            if view.center.y <= 0{
                view.center.y = 0
            }
            
            if view.center.x >= 300{
                view.center.x = 300
            }
            if view.center.y >= 200{
                view.center.y = 200
            }
            
            
            switch view {
            
            case cpOneView :
                bezierFrame.cpOne = cpOneView.frame.origin
                //println(bezierFrame.cpOne)
            case cpTwoView :
                bezierFrame.cpTwo = cpTwoView.frame.origin
                //println(bezierFrame.cpTwo)
            
            default :
                println("no pointSelected")
                

                }
            let result = bezierFrame.cubicBezier(0.5, start: 0, c1: cpOneView.center.x , c2: cpTwoView.center.x, end: 1)
            println(result)
            
            bezierFrame.setNeedsDisplay()
            
        }
            
        
    
        recognizer.setTranslation(CGPointZero, inView: bezierFrame)
        
        println(bezierFrame.cpOne)
        println(bezierFrame.cpTwo)
        
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as! UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    

}
