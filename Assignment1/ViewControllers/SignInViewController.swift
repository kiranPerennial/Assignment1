//
//  SignInViewController.swift
//  Assignment1
//
//  Created by APPLE on 08/11/21.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.view.endEditing(true)
    }
    
    func setupUI() {
        self.signupButton.isEnabled = false
        self.title = "Log In"
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        store.dispatch(SignupAction(user: User(email: emailTextField.text!, password: passwordTextField.text!, taskList: [])))
        navigationController?.popViewController(animated: true)
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
