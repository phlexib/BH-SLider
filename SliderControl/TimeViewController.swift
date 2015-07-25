//
//  TimeViewController.swift
//  BH Slider
//
//  Created by ben on 18/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    let realTimeViewController = RealtimeViewController()
    
    var hrString : String = "B"
    var minString : String = "M"
    var secString : String = "S"
    var recTime :CalcTime = CalcTime(timeInSeconds: 3600)
    var playTime :CalcTime = CalcTime(timeInSeconds: 10)
    var framerate : Int = 24
    var selectedTime : UIButton?
    
    @IBOutlet weak var hrBtn: UIButton!
    @IBOutlet var mnBtn: UIButton!
    @IBOutlet weak var secBtn: UIButton!
    
    
    @IBAction func backToMenu(sender: AnyObject) {
    }
    
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        var destViewController : RealtimeViewController = sender.destinationViewController as! RealtimeViewController
        destViewController.recTime = recTime
        destViewController.playTime = playTime
        
    }
    
    
    @IBAction func minTime(sender: UIButton) {
        if selectedTime != nil{
            switch selectedTime! {
            case hrBtn!:
                recTime.subTime("hours")
                //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                upDateText(recTime)
                
            case mnBtn! :
                recTime.subTime("minutes")
                // timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                upDateText(recTime)
                
            case secBtn! :
                recTime.subTime("seconds")
                //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
                upDateText(recTime)
            default :
                println("sender is not Hr , MN , SEC")
            }
            
            println(recTime.description())
        }
    }
    
    @IBAction func plusTime(sender: UIButton) {
        if selectedTime != nil{
            
        switch selectedTime! {
        case hrBtn!:
            recTime.addTime("hours")
            //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
            upDateText(recTime)
            
        case mnBtn! :
            recTime.addTime("minutes")
            //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
            upDateText(recTime)
            
        case secBtn! :
            recTime.addTime("seconds")
            //timelapseTime.formatTimeFromSec(timelapseTime.totalTime)
            upDateText(recTime)
        default :
            println("sender is not Hr , MN , SEC")
        }

        println(recTime.description())
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upDateText(recTime)
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
}
}
