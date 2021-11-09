//
//  TaskViewController.swift
//  Assignment1
//
//  Created by APPLE on 08/11/21.
//

import UIKit
import ReSwift

class TaskViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateTimeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.title = "Add Todo"
        self.saveButton.isEnabled = false
        self.dateTimeTextField.setInputViewDatePicker(target: self, selector: #selector(actionDone))
        self.dateTimeTextField.delegate = self
        self.titleTextField.delegate = self
    }
    
    @objc func actionDone() {
        if let datePicker = self.dateTimeTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.dateTimeTextField.text = dateformatter.string(from: datePicker.date)
        }
        self.dateTimeTextField.resignFirstResponder()
        self.saveButton.isEnabled =  self.validateFields(text: titleTextField.text) && self.validateFields(text: dateTimeTextField.text)
    }

    @IBAction func actionSaveTask(_ sender: Any) {
        let task = Task(title: titleTextField.text ?? "", dateTime: dateTimeTextField.text ?? "")
        store.dispatch(NewTaskAction(newTask: task))
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateFields(text:String?) -> Bool {
        if let text = text {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return (text.count < 3 || trimmedText.count == 0) ? false : true
        }
        return false
    }
}

extension TaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, F range: NSRange, replacementString string: String) -> Bool {
        self.saveButton.isEnabled =  self.validateFields(text: titleTextField.text) && self.validateFields(text: dateTimeTextField.text)
        return true
    }
}


