import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
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
        errorLabel.text = ""
        signupButton.isEnabled = false
        self.view.endEditing(true)
    }
    
    func setupUI() {
        self.signupButton.isEnabled = false
        self.title = "Sign Up"
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if let allUser = ServiceRequest.retrieve("NewTaskList.json", as: [User].self){
            let user = allUser.filter{ $0.email == emailTextField.text }
            if user.count == 0 {
                store.dispatch(SignupAction(user: User(email: emailTextField.text!, password: passwordTextField.text!, taskList: [])))
                navigationController?.popViewController(animated: true)
            } else {
                emailTextField.text = ""
                passwordTextField.text = ""
                errorLabel.text = "* Please Enter Valid Email And Password"
                signupButton.isEnabled = false
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

extension SignInViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        signupButton.isEnabled = validateFields(textFieldType: .email, text: emailTextField.text) && validateFields(textFieldType: .password, text: passwordTextField.text)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
