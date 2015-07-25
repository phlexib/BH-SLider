//
//  Timelapse.swift
//  Arduino_Servo
//
//  Created by ben on 12/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation

class Timelapse{
    
    var name : String = ""
    var numberOfShot : Int = 0
    var exposureTIme : Int = 0
    var startPosition: Int = 0
    var endPosition : Int = 0
    var hours : Int8 = 0
    var minutes : Int8 = 0
    var seconds : Int8 = 0
    var framerate : Float = 24.0
    var finalDuration : Int = 0
    var totalTime = CalcTime()
    
    var totalDuration : Int{
        get{
            
            return Int(hours)*3600 + Int(minutes)*60 + Int(seconds)
        }
    }
    var interval : Int {
        get{
            return totalDuration/numberOfShot
            
        }
    }
    
    ////// INIT FUNCTIONS
    
    init(name: String, numberOfShots : Int, timeInSeconds : CalcTime , startPosition : Int, endPosition : Int){
        self.name = name
        self.totalTime = timeInSeconds
        self.numberOfShot = numberOfShots
        self.hours = timeInSeconds.hours
        self.minutes = timeInSeconds.minutes
        self.seconds = timeInSeconds.seconds
        self.startPosition = startPosition
        self.endPosition = endPosition
        
    }
    
//    init(name: String, numberOfShots : Int, hours: Int, minutes : Int, seconds : Int , startPosition : Int, endPosition : Int){
//        self.name = name
//        self.numberOfShot = numberOfShots
//        self.hours = totalTime.hours
//        self.minutes = totalTime.minutes
//        self.seconds = totalTime.seconds
//        self.startPosition = startPosition
//        self.endPosition = endPosition
//        
//    }

    /////// FUNCTIONS 
    
    // Total Time in seconds
//    func TotalTimeSum( hour: Int , minute: Int, second : Int) -> Int{
//        let totalTimeSum = (hour*3600) + (minute*60) + second
//        println("Total duration is \(TotalTimeSum)")
//        return totalTimeSum;
//    }
    
    // Find Interval
    func calcInterval ( totalDuration:Int, numberOfPictures : Int) ->Int{
        let interval = totalDuration/numberOfPictures
        return interval;
    }
    
    // Description
    func description()->String{
        
        let descriptionString = "Timelapse \(self.name) has a duration of \(finalDuration) seconds with \(numberOfShot) shots taken every \(interval)."
        
        println(descriptionString)
        return descriptionString
    }
    
    
    
    
}
