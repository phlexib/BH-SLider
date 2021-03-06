//
//  Timelapse.swift
//  Arduino_Servo
//
//  Created by ben on 12/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation

class Timelapse{
    
    // Variables
    var name : String = ""
    var numberOfShot : Int = 0
    var exposureTime : Int = 0
    var startPosition: Int = 0
    var endPosition : Int = 0
    var framerate : Int = 24
    var recTime : CalcTime
    var playTime : CalcTime
    var linearStepArray = [Float]()
    var bezierArray = [Float]()
    var bezierStepArray = [AnyObject]()
    
    var stepIncrement : Int {
        get{
            return Int(distance/(numberOfShot))
        }
    }
    
    //Mark:- Computed variables
    
    var interval : Int {
        get{
            if recTime.totalTime == 0 || playTime.totalTime == 0{
                return 0
            }
            else{
                return recTime.totalTime/numberOfShot
            }
        }
    }
    
    var distance : Int {
        get{
            return abs(endPosition - startPosition)
        }
    }
    
    
    ///MARK:- INIT FUNCTIONS
    init(recTime : Int, playTime : Int){
        self.recTime = CalcTime(timeInSeconds: recTime)
        self.playTime = CalcTime(timeInSeconds: playTime)
        
    }
    
    init(name: String, playTimeInSeconds : CalcTime, recTimeInSeconds : CalcTime , framerate : Int, startPosition : Int, endPosition : Int){
        
        self.playTime = playTimeInSeconds
        self.recTime = recTimeInSeconds
        self.name = name
        self.framerate = framerate
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.numberOfShot = playTime.totalTime * framerate
        self.distance
        self.stepIncrement
        print("distance is \(distance) and stepIncrement is \(stepIncrement)")
        makeLinearStepsArray()
        
    }
    
  
    // Description
    func description()->String{
        
        let descriptionString = "Timelapse \(self.name) has a duration of \(playTime.totalTime) seconds with \(numberOfShot) shots taken every \(interval) seconds for \(recTime.totalTime)."
        
        return descriptionString
    }
    
    func makeLinearStepsArray() {
        //linearStepArray.append(Float(self.startPosition))
        for shot in 0..<numberOfShot-1{
            let newStep = Int(self.startPosition)+(Int(shot) * stepIncrement)
            linearStepArray.append(Float(newStep))
        }
        linearStepArray.append(Float(self.endPosition))
        print(linearStepArray)
    }

    func makeBezierStepArray(linearArray : Array<Float>){
        var newBezierArray = [AnyObject]()
        for (var i = 0 ; i < linearArray.count ; i++){
            if i == 0{
                newBezierArray.append(0)
            }else{
                let newValue : Int = Int(round(linearArray[i] - linearArray[i-1]))
                newBezierArray.append(newValue as Int)
            }
            
        }
        bezierStepArray = newBezierArray
    }
    
    
}
