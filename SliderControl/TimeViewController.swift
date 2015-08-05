//
//  TimeViewController.swift
//  BH Slider
//
//  Created by ben on 18/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

let timeChangedeNotification = "kTimeChangedNotification"

class TimeViewController: UIViewController {
    
    //MARK: - STORED VARIABLES
    
    let realTimeViewController = RealtimeViewController()
    var hrString : String = "B"
    var minString : String = "M"
    var secString : String = "S"
    var recTime :CalcTime = CalcTime(timeInSeconds: 3600)
    var playTime :CalcTime = CalcTime(timeInSeconds: 10)
    var framerate : Int = 24
    var selectedTime : UIButton?
    var selectedType : String = "RECTIME"
    
    @IBOutlet weak var hrBtn: UIButton!
    @IBOutlet var mnBtn: UIButton!
    @IBOutlet weak var secBtn: UIButton!
    
    
    
    
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    @IBAction func minTime(sender: UIButton) {
        if selectedTime != nil{
            var withTime = CalcTime(timeInSeconds: recTime.totalTime)
            
            if selectedType == "RECTIME"{
                upDateText(recTime)
                withTime = recTime
            }
            else if selectedType == "PLAYTIME"{
                upDateText(playTime)
                withTime = playTime
            }
            
            
            switch selectedTime! {
            case hrBtn!:
                withTime.subTime("hours")
                //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                
            case mnBtn! :
                withTime.subTime("minutes")
                //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                
                
            case secBtn! :
                withTime.subTime("seconds")
                //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                
            default :
                println("sender is not Hr , MN , SEC")
            }
            NSNotificationCenter.defaultCenter().postNotificationName(timeChangedeNotification, object: self)
            
            sendTimeChangedNotification()
            println(withTime.description())
        }    }
    
    @IBAction func plusTime(sender: UIButton) {
        if selectedTime != nil{
            var withTime = CalcTime(timeInSeconds: recTime.totalTime)
            
            if selectedType == "RECTIME"{
                upDateText(recTime)
                withTime = recTime
            }
            else if selectedType == "PLAYTIME"{
                upDateText(playTime)
                withTime = playTime
            }
            
            
            switch selectedTime! {
            case hrBtn!:
                withTime.addTime("hours")
                //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                
            case mnBtn! :
                withTime.addTime("minutes")
                //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                
                
            case secBtn! :
                withTime.addTime("seconds")
                //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                
            default :
                println("sender is not Hr , MN , SEC")
            }
            NSNotificationCenter.defaultCenter().postNotificationName(timeChangedeNotification, object: self)
            
            sendTimeChangedNotification()
            println(withTime.description())
        }
    }
    
    
    
    
    
    @IBAction func timeButtonSelected(sender: UIButton) {
        let selectedColor = UIColor(red: 0.2, green: 1, blue: 0.8, alpha: 1)
        let selectedBgColor = UIColor(white: 1, alpha: 0)
        
        //selectedTime = sender
        selectedTime = sender
        println(selectedTime!.titleLabel!.text)
        
        
        
        
        
        if selectedTime != nil{
            
            selectedTime!.setTitleColor(selectedColor, forState: UIControlState.Selected)
            selectedTime!.setTitleShadowColor(selectedBgColor, forState: UIControlState.Selected)
            selectedTime!.setTitleShadowColor(selectedBgColor, forState: UIControlState.Highlighted)
            
            var result : String = ""
            switch selectedTime! {
            case hrBtn :
                hrBtn.selected = true
                mnBtn.selected = false
                secBtn.selected = false
                result = "Hour Selected"
                
                
            case mnBtn :
                mnBtn.selected = true
                hrBtn.selected = false
                secBtn.selected = false
                result = "Minutes Selected"
                
            case secBtn :
                secBtn.selected = true
                hrBtn.selected = false
                mnBtn.selected = false
                result = "Seconds Selected"
            default :
                result="no btn selected"
            }
            println(result)
        }
    }
    
    func upDateText (withTime : CalcTime){
        hrBtn.setTitle(withTime.strHours + " H", forState: UIControlState.Selected)
        hrBtn.setTitle(withTime.strHours + "H", forState: UIControlState.Normal)
        mnBtn.setTitle(withTime.strMinutes + "M", forState: UIControlState.Selected)
        mnBtn.setTitle(withTime.strMinutes + "M", forState: UIControlState.Normal)
        secBtn.setTitle(withTime.strSeconds + "S", forState: UIControlState.Selected)
        secBtn.setTitle(withTime.strSeconds + "S", forState: UIControlState.Normal)
        
    }
    
    func sendTimeChangedNotification(){
        switch selectedType {
        case "RECTIME":
            upDateText(recTime)
        case "PLAYTIME":
            upDateText(playTime)
        default :
            
            upDateText(recTime)
        }
        
        
        
    }
    
    func updateTypeNotification(notification: NSNotification){
        
        let notificationButton = notification.userInfo!["button"] as? UIButton
        selectedType = notificationButton!.titleLabel!.text!
        
        switch selectedType {
        case "RECTIME":
            upDateText(recTime)
        case "PLAYTIME":
            upDateText(playTime)
        default :
            
            upDateText(recTime)
        }
        
    }
    
    
    
    //MARK: - Runtime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upDateText(recTime)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendTimeChangedNotification", name: timeChangedeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTypeNotification:", name: timeTypeNotification, object: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        println("view will disappear")
        realTimeViewController.recTime = recTime
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        realTimeViewController.recTime = recTime
    }
}
