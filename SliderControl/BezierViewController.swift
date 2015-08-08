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
    @IBOutlet weak var dotView: DotPreview!
    
    var numberOfShots = Int()
    var timelapse : Timelapse = Timelapse(recTime: 3600, playTime: 10)
    var stepsArray : Array<Float> = []
    
    
    
    override func viewDidLoad() {
        
        numberOfShots = timelapse.numberOfShot
        
        stepsArray=timelapse.linearPosistionArray
        println(stepsArray)
        self.dotView.positionArray = stepsArray
        self.dotView.makePointArray(stepsArray)
        self.dotView.intervalPoint = CGFloat (timelapse.stepIncrement)
        self.dotView.setNeedsDisplay()
        
        var invertScale = CGAffineTransformMakeScale(1, -1)
        bezierFrame.transform = invertScale
        
//        UIView.animateWithDuration(2, delay: 2, options: nil, animations: {
//            self.bezierFrame.frame = CGRect(x: 320-50, y: 120, width: 50, height: 50)
//            //self.bezierFrame.backgroundColor = UIColor.redColor()
//            }, completion: { finished in
//                // any code entered here will be applied
//                // once the animation has completed
//                
//        })
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
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
            if view.center.y >= 300{
                view.center.y = 300
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
            
            bezierFrame.setNeedsDisplay()
            
            dotView.setNeedsDisplay()

            
        }
            
        
    
        recognizer.setTranslation(CGPointZero, inView: bezierFrame)
        
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

        super.touchesBegan(touches , withEvent:event)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
        if let touch = touches.first as? UITouch {
        }
    }

    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            
            let newArray = makeBezierArray(stepsArray)
            timelapse.bezierArray = newArray
            timelapse.makeBezierStepArray(timelapse.bezierArray)
            
            let floatArray = reduceArrayForDotPreview(timelapse.bezierStepArray as! [Float], maxPoint: 20)
            println("FLOAT ARRAY COUNT IS \(floatArray.count)")
            var cgFloatArray = [Float]()
            
            for item in floatArray {
                cgFloatArray.append(Float(item))
            }
            
            println("BEZIER ARRAY IS = \(timelapse.bezierArray) AND HAS \(timelapse.bezierArray.count)")
            println("BEZIERSTEP ARRAY IS = \(timelapse.bezierStepArray) AND HAS \(timelapse.bezierStepArray.count)")
            println("CGFLOAT ARRAY IS = \(cgFloatArray) AND HAS \(cgFloatArray.count)")
            
           
//            self.dotView.intervalPoint = CGFloat (timelapse.stepIncrement)
                        
        
            
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destinationViewController as! UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    
    func cubicBezier(positionPoint : CGFloat , a : CGFloat , b : CGFloat , c : CGFloat , d : CGFloat    ) -> CGFloat{
    
    let t : CGFloat = positionPoint
    let tSquared = t * t
    let tCubed = tSquared * t
        
        return a + (-a * 3 + t * (3 * a - a * t)) * t
            + (3 * b + t * (-6 * b + b * 3 * t)) * t
            + (c * 3 - c * 3 * t) * tSquared
            + d * tCubed
    }
    
   
    
    
    func makeBezierArray (inArray : [Float])  -> Array<Float>{
        var forBezierArray = [Float]()
        let delta = CGFloat(timelapse.distance) / self.bezierFrame.size.width
        
        for point in inArray{
            let start : CGFloat = 0
            let end : CGFloat = 1
            let frameSize : CGFloat = self.bezierFrame.size.width
            let toCGFloat = CGFloat(point) / delta
            let newPoint = cubicBezier( (toCGFloat / frameSize), a: start, b: (self.bezierFrame.cpOne.x / frameSize), c: (self.bezierFrame.cpTwo.x / frameSize), d: end)
            let newFloatPoint = Float((newPoint) * frameSize * delta)
            forBezierArray.append(newFloatPoint)
            
        }
        return forBezierArray
    }
    
    func reduceArrayForDotPreview(myObject : Array<Float> , maxPoint : Int)->Array<Float>{
        let delta = myObject.count / maxPoint
        var reducedArray = [Float]()
        var filter = myObject.count % maxPoint
        for (index, value) in enumerate(myObject){
            if index % delta == 0 {
            reducedArray.append(value / Float(timelapse.distance)  * Float(self.bezierFrame.size.width))
            }
        }
        return reducedArray
    }
    
    }
