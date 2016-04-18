//
//  AddViewController.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

class AddViewController: UIViewController, UITextFieldDelegate, AddViewInterface {
    var eventHandler: AddModuleInterface?

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    var minimumDate: NSDate = NSDate()
    var transitioningBackgroundView: UIView = UIView()

    @IBAction func save(sender: AnyObject) {
        if let eventHandler = eventHandler, text = nameTextField.text {
            eventHandler.saveAddActionWithName(text, dueDate: datePicker.date)
        }
    }

    @IBAction func cancel(sender: AnyObject) {
        nameTextField.resignFirstResponder()
        eventHandler?.cancelAddAction()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(dismiss))

        transitioningBackgroundView.userInteractionEnabled = true

        nameTextField.becomeFirstResponder()

        if let realDatePicker = datePicker {
            realDatePicker.minimumDate = minimumDate
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        nameTextField.resignFirstResponder()
    }

    func dismiss() {
        eventHandler?.cancelAddAction()
    }

    func setEntryName(name: String) {
        nameTextField.text = name
    }

    func setEntryDueDate(date: NSDate) {
        if let realDatePicker = datePicker {
            realDatePicker.minimumDate = date
        }
    }

    func setMinimumDueDate(date: NSDate) {
        minimumDate = date

        if let realDatePicker = datePicker {
            realDatePicker.minimumDate = date
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
