//
//  RealtimeViewController.swift
//  Arduino_Servo
//
//  Created by ben on 08/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

let timeTypeNotification = "ktimeTypeNotification"

class RealtimeViewController: UIViewController, UITextFieldDelegate{
    
    
    // MARK: - STORED VARIABLES
    
    
    let transitionManager = TransitionManager()
    var timerTXDelay: NSTimer?
    var allowTX = true
    
    var timeView : UIView?
    var strName : String = ""
    var framerate = 4
    var jogLocation = CGPoint (x: 0, y: 0)
    var currentPosition = 0
    var inPoint = 0
    var outPoint = 100
    var startLimit = 0
    var endLimit = 100
    var recHours : Int8 = 0
    var recMinutes : Int8 = 30
    var recSeconds : Int8 = 0
    var playHours : Int8 = 0
    var playMinutes : Int8 = 0
    var playSeconds : Int8 = 10
    var recTime : CalcTime = CalcTime(timeInSeconds: 3600)
    var playTime : CalcTime =  CalcTime(timeInSeconds: 10)
    var timelapse : Timelapse = Timelapse(recTime: 0, playTime: 0)
    var selectedTime : UIButton?
    
    // MARK: - viewControllers Variables
    
    
    var timeViewController : TimeViewController?
    var bezierViewcontroller : BezierViewController?
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    
    /// MARK: - OUTLETS
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgBluetoothStatus: UIImageView!
    @IBOutlet weak var previewPosition: UISlider!
    @IBOutlet weak var setStartLimit: UIButton!
    @IBOutlet weak var setInPoint: UIButton!
    @IBOutlet weak var fastBackward: UIButton!
    @IBOutlet weak var slowBackward: UIButton!
    @IBOutlet weak var slowForward: UIButton!
    @IBOutlet weak var fastForward: UIButton!
    @IBOutlet weak var setEndLimit: UIButton!
    @IBOutlet weak var setOutPoint: UIButton!
    @IBOutlet weak var jogView: UIView!
    
    
    @IBOutlet weak var recTimeBtn: UIButton!
    @IBOutlet weak var playTimeBtn: UIButton!
    @IBOutlet weak var intervalBtn: UIButton!
    @IBOutlet weak var displayRecTime: UILabel!
    @IBOutlet weak var displayPlayTime: UILabel!
    @IBOutlet weak var displayInterval: UILabel!
    @IBOutlet weak var sceneNameText: UITextField!
    @IBOutlet weak var framrateText: UITextField!
    
    @IBOutlet weak var dotView: DotPreview!
    
    //    @IBAction func positionSliderChanged(sender: UISlider) {
    //        var intPosition:Int = Int(positionSlider.value)
    //        sliderValue.text = NSString(format: "%i",intPosition ) as String
    //        self.sendPosition(UInt8(sender.value))
    //    }
    
    
    
    
    //// CUSTOM BUTTON VIEW
    
    
    //// MARK: - IBACTIONS
    
    @IBAction func timeButtonSelected(sender: UIButton) {
        self.view.addSubview(containerView)
        activeViewController = timeViewController
        
        
        
        let selectedColor = UIColor(red: 0.2, green: 1, blue: 0.8, alpha: 1)
        let selectedBgColor = UIColor(white: 1, alpha: 0)
        
        selectedTime = sender
        selectedTime?.setTitleColor(selectedColor, forState: UIControlState.Selected)
        selectedTime?.backgroundColor = selectedBgColor
        selectedTime?.setTitleShadowColor(selectedBgColor, forState: UIControlState.Selected)
        selectedTime?.setTitleShadowColor(selectedBgColor, forState: UIControlState.Highlighted)
        
        var result : String = ""
        switch selectedTime! {
        case recTimeBtn :
            selectedTime?.selected = true
            playTimeBtn.selected = false
            intervalBtn.selected = false
            result = "RecTime Selected"
            
            
        case playTimeBtn :
            selectedTime?.selected = true
            recTimeBtn.selected = false
            intervalBtn.selected = false
            result = "PlaytimeBtn Selected"
        case intervalBtn :
            selectedTime?.selected = true
            recTimeBtn.selected = false
            playTimeBtn.selected = false
            result = "Interval Selected"
        default :
            result="no btn selected"
        }
        let infoNotication  = ["button" : selectedTime!]
        NSNotificationCenter.defaultCenter().postNotificationName(timeTypeNotification, object: self, userInfo : infoNotication)
        
    }
    
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        UIView.animateWithDuration(0.5, animations: { self.previewPosition.alpha = 1
        })
        
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        var multiplierDirection : Int = 0
        var directionString = "forward"
        
        switch sender {
        case fastBackward :
            multiplierDirection = 2
            directionString = "backward"
        case fastForward :
            multiplierDirection = 2
            directionString = "forward"
        case slowBackward :
            multiplierDirection = 1
            directionString = "backward"
        case slowForward :
            multiplierDirection = 1
            directionString = "forward"
            
        default :
            multiplierDirection = 0
            directionString = "forward"
        }
        
        let speedString = "\(directionString) \(multiplierDirection)"
        self.sendString(speedString)
    }
    
    
    @IBAction func buttonStop(sender: AnyObject) {
        let stop = "stop 180"
        self.sendString(stop)
    }
    
    
    @IBAction func doInPoint(sender: UIButton) {
        
    }
    
    @IBAction func doOutPoint(sender: UIButton) {
    }
    
    @IBAction func doMin(sender: AnyObject) {
    }
    
    @IBAction func doMax(sender: AnyObject) {
    }
    
    @IBAction func clearTimelapse(sender: UIButton) {
        
    }
    
    
    @IBAction func buttonTimelapse(sender: UIButton) {
        setTimelapse()
    }
    
    @IBAction func showCurve(sender: AnyObject) {
    }
    
    
    
    
    // MARK: - Runtime
    //// OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sliderImage = UIImage(named: "Bar")
        
        activeViewController = timeViewController
        self.containerView.removeFromSuperview()
        
        // ASSIGN TEXTFIELDS
        
        recHours = recTime.hours
        recMinutes = recTime.minutes
        recSeconds = recTime.seconds
        playTime.hours = playHours
        playTime.minutes = playMinutes
        playTime.seconds = playSeconds
        playTime.totalTimeFromTime()
        
        
        updateDisplayText()
        
        // CREATE THE DOT VIEW
        let myArray  :Array<Float> = [0.0,10.0,20.0,40.0]
        self.dotView.positionArray = myArray
        
        
        // Set thumb image on slider
        previewPosition.setThumbImage(sliderImage, forState: UIControlState.Normal)
        
        // Watch Bluetooth connection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEServiceChangedStatusNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("hasNewPositionValue:"), name: PositionValueNotification, object: nil)
        // Start the Bluetooth discovery process
        btDiscoverySharedInstance
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTimeNotification", name: timeChangedeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTypeNotification", name: timeTypeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: BLEServiceChangedStatusNotification, object: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        updateDisplayText()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopTimerTXDelay()
    }
    
    // MARK: - Toucch Functions
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch {
            // ...
        }
        super.touchesBegan(touches , withEvent:event)
        self.view.endEditing(true)
        
        if(containerView != nil) {
            println(self.activeViewController)
            //timelapseTime = currentController.timelapseTime
            self.removeInactiveViewController(timeViewController)
            containerView.removeFromSuperview()
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        
        if let touch = touches.first as? UITouch {
            
            jogLocation = touch.locationInView(jogView)
            if jogView.pointInside(jogLocation, withEvent: event){
                let jogValue = jogLocation.x - 122.5
                let intJogValue = Int(jogValue)
                
                var directionString = "FW"
                
                if jogValue < 0 {
                    directionString = "BW"
                }
                    
                else{
                    directionString = "FW"
                }
                
                var multiplierDirection = abs(jogValue)
                println(multiplierDirection)
                
                
                let speedString = "\(directionString) \(jogValue)"
                self.jogString(speedString)
                
            }
            
        }
        super.touchesBegan(touches , withEvent:event)
        
        
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch {
            let stop = "STOP 180"
            self.sendString(stop)
        }
        super.touchesEnded(touches , withEvent:event)
    }
    
    
    // MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        UIView.animateWithDuration(0.5, animations: { self.previewPosition.alpha = 0})
        let segueID : String = segue.identifier!
        println(segueID)
        
        switch segueID{
        case "timeView":
            var destViewController : TimeViewController = segue.destinationViewController as! TimeViewController
            destViewController.recTime = recTime
            destViewController.playTime = playTime
            destViewController.framerate = framrateText.text.toInt()!
            destViewController.transitioningDelegate = self.transitionManager
            
        case "containerSegue":
            
            let destViewController : TimeViewController = segue.destinationViewController as! TimeViewController
            destViewController.recTime = recTime
            destViewController.playTime = playTime
            destViewController.framerate = framrateText.text.toInt()!
            destViewController.transitioningDelegate = self.transitionManager
            
        case "curveView":
            var destViewController : BezierViewController = segue.destinationViewController as! BezierViewController
            destViewController.timelapse = self.timelapse
            destViewController.transitioningDelegate = self.transitionManager
            
            
        default:
            println("destination controller is not Bezier or Timeview")
        }
        
    }
    
    
    
    //MARK: - CUSTOM FUNCTIONS
    
    func updateDisplayText(){
        self.displayRecTime.text = recTime.strHours + "h" + recTime.strMinutes + "m" + recTime.strSeconds + "s"
        self.displayPlayTime.text = playTime.strHours + "h" + playTime.strMinutes + "m" + playTime.strSeconds + "s"
        self.displayInterval.text = "\(timelapse.interval)"+" sec"
        
    }
    
    
    func setTimelapse() {
        
        let sceneName : String = sceneNameText.text!
        
        
        framerate = framrateText.text.toInt()!
        
        timelapse  = Timelapse(name: "MyTimelapse", playTimeInSeconds: playTime, recTimeInSeconds: recTime, framerate:self.framerate, startPosition: 0, endPosition: 1000)
        self.displayInterval.text = "\(timelapse.interval)"+" sec"
        
        println(timelapse.description())
    }
    
    
    
    func sendString(toSend: String){
        if !allowTX {
            return
        }
        // Send position to BLE Shield (if service exists and is connected)
        if let bleService = btDiscoverySharedInstance.bleService {
            let stringToSend: String = toSend+"!"
            bleService.writeString(stringToSend)
            
            // 5
            // Start delay timer
            allowTX = false
            if timerTXDelay == nil {
                timerTXDelay = NSTimer.scheduledTimerWithTimeInterval(0.1,
                    target: self,
                    selector: Selector("timerTXDelayElapsed"),
                    userInfo: nil,
                    repeats: false)
            }
        }
    }
    
    func jogString(toSend: String){
        if !allowTX {
            return
        }
        // Send position to BLE Shield (if service exists and is connected)
        if let bleService = btDiscoverySharedInstance.bleService {
            let stringToSend: String = toSend+"!"
            bleService.writeString(stringToSend)
            
            // 5
            // Start delay timer
            allowTX = false
            if timerTXDelay == nil {
                timerTXDelay = NSTimer.scheduledTimerWithTimeInterval(0.5,
                    target: self,
                    selector: Selector("timerTXDelayElapsed"),
                    userInfo: nil,
                    repeats: false)
            }
        }
    }
    
    func getString(toSend: String){
        if !allowTX {
            return
        }
        // Send position to BLE Shield (if service exists and is connected)
        if let bleService = btDiscoverySharedInstance.bleService {
            bleService.writeString(toSend)
            
            // 5
            // Start delay timer
            allowTX = false
            if timerTXDelay == nil {
                timerTXDelay = NSTimer.scheduledTimerWithTimeInterval(0.5,
                    target: self,
                    selector: Selector("timerTXDelayElapsed"),
                    userInfo: nil,
                    repeats: false)
            }
        }
    }
    
    func connectionChanged(notification: NSNotification) {
        // Connection status changed. Indicate on GUI.
        let userInfo = notification.userInfo as! [String: Bool]
        
        dispatch_async(dispatch_get_main_queue(), {
            // Set image based on connection status
            if let isConnected: Bool = userInfo["isConnected"] {
                if isConnected {
                    self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Connected")
                    
                    // Send current slider position
                    //self.sendPosition(UInt8( self.positionSlider.value))
                } else {
                    self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Disconnected")
                }
            }
        });
    }
    
    func hasNewPositionValue(notification: NSNotification) {
        // Connection status changed. Indicate on GUI.
        let userInfo = notification.userInfo as! [String: Bool]
        
        dispatch_async(dispatch_get_main_queue(), {
            // Set image based on connection status
            if let bleService = btDiscoverySharedInstance.bleService {
                let newPosition = bleService.position
                self.previewPosition.value = newPosition
            }
        });
    }
    
    
    func timerTXDelayElapsed() {
        self.allowTX = true
        self.stopTimerTXDelay()
        
        // Send current slider position
        //self.sendPosition(UInt8(self.positionSlider.value))
    }
    
    func stopTimerTXDelay() {
        if self.timerTXDelay == nil {
            return
        }
        
        timerTXDelay?.invalidate()
        self.timerTXDelay = nil
    }
    
    // MARK: - NOTIFICATION FUNCTIONS
    
    func updateTimeNotification(){
        setTimelapse()
        updateDisplayText()
    }
    
    func updateTypeNotification(){
        updateDisplayText()
    }
    
    
    // MARK: - TextFieldDelegate
    //// TEXTFIELD DELEGATE
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        let maxLength = 2
        let currentString: NSString = textField.text
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    
    
    // MARK: - CONTAINER LOGIC
    
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
        }
    }
    
}

