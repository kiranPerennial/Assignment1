import UIKit
import ReSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.logInButton.isEnabled = false
        self.errorLabel.text = ""
        self.view.endEditing(true)
    }
    
    func setupUI() {
        self.logInButton.isEnabled = false
        self.title = "Log In"
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    @IBAction func actionLogin(_ sender: Any) {
        if let allUser = ServiceRequest.retrieve("NewTaskList.json", as: [User].self) {
            let user = allUser.filter{ $0.email == emailTextField.text && $0.password == passwordTextField.text }
            if user.count > 0 {
                store.dispatch(LoginAction(user: user[0]))
                performSegue(withIdentifier: "showTasks", sender: sender)
            } else {
                emailTextField.text = ""
                passwordTextField.text = ""
                errorLabel.text = "* Please Enter Valid Email And Password"
                logInButton.isEnabled = false
            }
        }
    }
    
    func validateFields(textFieldType:TextFieldType, text:String?) -> Bool {
        if textFieldType == .email, let email = text, !(email.isEmpty), email.isValidEmail() {
            return true
        } else if textFieldType == .password, let password = text, password.isValidPassword() {
            return true
        }
        return false
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        logInButton.isEnabled = validateFields(textFieldType: .email, text: emailTextField.text) && validateFields(textFieldType: .password, text: passwordTextField.text)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
