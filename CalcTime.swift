//
//  CalcTime.swift
//  Arduino_Servo
//
//  Created by ben on 17/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class CalcTime {

    var totalTime : Int
    
    
    var hours : Int8 = 0 {
        didSet{
            let newTime = (Int(hours)*3600 + Int(minutes)*60 + Int(seconds))
            totalTime = newTime
        }
    }
    var minutes : Int8 = 0 {
        didSet{
            let newTime = (Int(hours)*3600 + Int(minutes)*60 + Int(seconds))
            totalTime = newTime
        }
    }
    var seconds : Int8 =  0 {
        didSet{
            let newTime = (Int(hours)*3600 + Int(minutes)*60 + Int(seconds))
            totalTime = newTime
        }
    }
    
    
    var strHours : String{
        get{
            return  hours > 9 ? String(hours) : "0" + String(hours)
        }
    }
    
    var strMinutes : String{
        get{
            return minutes > 9 ? String(minutes) : "0" + String(minutes)
        }
    }
    
    var strSeconds : String{
        get{
            return seconds > 9 ? String(seconds) : "0" + String(seconds)
        }
    }
    
    
    //MARK:- init functions
    init(timeInSeconds : Int){
        totalTime = timeInSeconds
        formatTimeFromSec(totalTime)
    }
    
    
    
    //MARK:- Main Time Operations
    func formatTimeFromSec(totalSeconds: Int) {
        
        seconds = Int8 (totalSeconds % 60)
        minutes = Int8 ((totalSeconds / 60) % 60)
        hours = Int8 (totalSeconds / 3600)
    }
    
    func totalTimeFromTime () -> Int{
        totalTime = (Int(hours)*3600 + Int(minutes)*60 + Int(seconds))
        return totalTime
    }
    
    // Description
    func description() -> String{
        
        let descriptionString = "\(strHours):\(strMinutes):\(strSeconds) - "
        let totalDescription = "total time in seconds is \(totalTime)"
        return descriptionString + totalDescription
    }
    
    /// Add Unit to Time Element
    func addTime(inputTime : String){
        
        switch inputTime{
        case "hours":
            totalTime += 3600
        case "minutes" :
            totalTime += 60
        case "seconds" :
            totalTime += 1
            
        default :
            totalTime += 0
        }
        formatTimeFromSec(totalTime)
    }
    
    /// Substract Unit to Time Element
    func subTime(inputTime : String){
        
        switch inputTime{
        case "hours":
            totalTime -= 3600
        case "minutes" :
            totalTime -= 60
        case "seconds" :
            totalTime -= 1
            
        default :
            totalTime -= 0
        }
        formatTimeFromSec(totalTime)
    }
    
}


