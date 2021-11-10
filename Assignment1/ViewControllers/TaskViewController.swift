import UIKit
import ReSwift

class TaskViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateTimeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    var selectedTask: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
    }
    
    func setupUI() {
        self.title = "TODO"
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
        store.dispatch(AddUpdateTaskAction(newTask: task, selectedTask: selectedTask))
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.saveButton.isEnabled =  self.validateFields(text: titleTextField.text) && self.validateFields(text: dateTimeTextField.text)
        return true
    }
}

extension TaskViewController: StoreSubscriber {
    func newState(state: AppState) {
        self.selectedTask = state.selectedTask
        self.titleTextField.text = state.selectedTask?.title
        self.dateTimeTextField.text = state.selectedTask?.dateTime
    }
}
