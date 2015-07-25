//
//  BTService.swift
//  Arduino_Servo
//
//  Created by Owen L Brown on 10/11/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import CoreBluetooth


/* Services & Characteristics UUIDs */
let BLEServiceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
let txCharUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
let rxCharUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"
let PositionValueNotification = "kPositionValueNotification"

class BTService: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var positionCharacteristic: CBCharacteristic?
    var stringCharacteristic: CBCharacteristic?
    var dataReceivedCharacteristics: CBCharacteristic?
    var position: Float = 0.0
    
  init(initWithPeripheral peripheral: CBPeripheral) {
    super.init()
    
    self.peripheral = peripheral
    self.peripheral?.delegate = self
  }
  
  deinit {
    self.reset()
  }
  
  func startDiscoveringServices() {
    self.peripheral?.discoverServices([BLEServiceUUID])
  }
  
  func reset() {
    if peripheral != nil {
      peripheral = nil
    }
    
    // Deallocating therefore send notification
    self.sendBTServiceNotificationWithIsBluetoothConnected(false)
  }
  
  // Mark: - CBPeripheralDelegate
  
  func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
    let txForBTService: [CBUUID] = [txCharUUID]
    let rxForBTService: [CBUUID] = [rxCharUUID]
    
    if (peripheral != self.peripheral) {
      // Wrong Peripheral
      return
    }
    
    if (error != nil) {
      return
    }
    
    if ((peripheral.services == nil) || (peripheral.services.count == 0)) {
      // No Services
      return
    }
    
    for service in peripheral.services {
      if service.UUID == BLEServiceUUID {
        peripheral.discoverCharacteristics(txForBTService, forService: service as! CBService)
        peripheral.discoverCharacteristics(rxForBTService, forService: service as! CBService)
        
      }
    }
  }
  
  func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
    if (peripheral != self.peripheral) {
      // Wrong Peripheral
      return
    }
    
    if (error != nil) {
      return
    }
    
    for characteristic in service.characteristics {
        
      if characteristic.UUID == txCharUUID {
        println("tx ok")
        self.positionCharacteristic = (characteristic as! CBCharacteristic)
        self.stringCharacteristic = (characteristic as! CBCharacteristic)

        peripheral.setNotifyValue(true, forCharacteristic: characteristic as! CBCharacteristic)
        
        // Send notification that Bluetooth is connected and all required characteristics are discovered
        self.sendBTServiceNotificationWithIsBluetoothConnected(true)
      }
        
        if characteristic.UUID == rxCharUUID {
            
            println("rx ok")
            
            self.dataReceivedCharacteristics = (characteristic as! CBCharacteristic)
            peripheral.setNotifyValue(true, forCharacteristic: characteristic as! CBCharacteristic)
            
            // Send notification that Bluetooth is connected and all required characteristics are discovered
            
        }
    }
  }

    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if characteristic.UUID == rxCharUUID{
            if characteristic.value != nil {
                let newData : NSData = characteristic.value
                var string  = NSString(data: newData, encoding:NSUTF8StringEncoding)
                self.position = string!.floatValue
            println("String: \(string)")
            self.sendPositionValue(true)
            }
        }
    }
  // Mark: - Private
  
    func writePosition(position: UInt8) {
        // See if characteristic has been discovered before writing to it
        if self.positionCharacteristic == nil {
            return
        }
        
        // Need a mutable var to pass to writeValue function
        var positionValue = position
        let data = NSData(bytes: &positionValue, length: sizeof(UInt8))
        self.peripheral?.writeValue(data, forCharacteristic: self.positionCharacteristic, type: CBCharacteristicWriteType.WithResponse)
    }
    

    
     func writeString(string:String)
    {
        let theString = string+"!"
        println("Write string: \(theString)")
        let data = NSData(bytes: theString, length: count(theString))
        writeRawData(data)
    }
    
    
    
    func writeRawData(data:NSData)
    {
        println("Write data: \(data)")
        
        if let stringCharacteristic = self.stringCharacteristic {
            
            if stringCharacteristic.properties & .WriteWithoutResponse != nil {
                peripheral!.writeValue(data, forCharacteristic: stringCharacteristic, type: .WithoutResponse)
            } else if stringCharacteristic.properties & .Write != nil {
                peripheral!.writeValue(data, forCharacteristic: stringCharacteristic, type: .WithResponse)
            } else {
                println("No write property on TX characteristics: \(stringCharacteristic.properties)")
            }
            
        }
    }
    
    
  func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
    let connectionDetails = ["isConnected": isBluetoothConnected]
    NSNotificationCenter.defaultCenter().postNotificationName(BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
  }
    func sendPositionValue(isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NSNotificationCenter.defaultCenter().postNotificationName(PositionValueNotification, object: self, userInfo: connectionDetails)
    }

}