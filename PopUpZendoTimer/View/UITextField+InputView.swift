//
//  UITextField+InputView.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/4/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .dateAndTime //2
        datePicker.setValue(UIColor.lightGray, forKeyPath: "textColor")
        self.inputView = datePicker //3
        self.inputView?.backgroundColor = UIColor.darkText
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        toolBar.barStyle = .black
        toolBar.isTranslucent = true
        toolBar.alpha = 1
        toolBar.tintColor = UIColor.lightGray
        toolBar.sizeToFit()
        
        
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}

extension UIDatePicker {

    var textColor: UIColor? {
        set {
             setValue(newValue, forKeyPath: "textColor")
            }
        get {
             return value(forKeyPath: "textColor") as? UIColor
            }
    }

    var highlightsToday : Bool? {
        set {
             setValue(newValue, forKeyPath: "highlightsToday")
            }
        get {
             return value(forKey: "highlightsToday") as? Bool
            }
    }
}

