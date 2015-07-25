//
//  CustomTextField.swift
//  Arduino_Servo
//
//  Created by ben on 13/07/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    
    

}
