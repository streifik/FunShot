//
//  LoginViewController.swift
//  teatApp
//
//  Created by streifik on 06.12.2022.
//
import UIKit
import CoreData

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Variables
    
    var email = String()
    var password = String()
    var user = User()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        self.setTextFildDelegates()
       // self.setTextFieldsStyle()
    }
    
    //    method
    func setTextFildDelegates() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func setTextFieldsStyle() {
        let textfields = [self.emailTextField, self.passwordTextField]
        
        for item in textfields {
            if let textfield = item {
                self.setPreferences(textfield)
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        
        // check empty fields
        
        if self.emailTextField.text == "" ||
            self.passwordTextField.text == "" {
            self.displayMessage(userMessage: "Enter all fields", completion: nil)
            
        } else {
            if let email = emailTextField.text {
                self.email = email
            }
            
            if let password = passwordTextField.text {
                self.password = password
            }
            
        // check data in CoreData
        
        self.showActivityIndicator()
        
        if (CoreDataManager.shared.checkIfUserExist(email: email)) {
            if (CoreDataManager.shared.checkIfPasswordMatch(email: email, password: password)){
                if let user = CoreDataManager.shared.fetchUserData(userEmail: email) {
                    Settings.shared.user = user
                    hideActivityIndicator()
                    if let loginState = CoreDataManager.shared.setLoginState(isLoggedIn: true, userEmail: email) {
                        if loginState.isLoggedIn == true {
                            NavigationManager.shared.navigateToProfileViewController(sender: self)
                        } else {
                            print("Error with setting login state")
                        }
                    } else {
                        print("Error with fetching login data")
                    }
                }
            } else {
                self.displayMessage(userMessage: "Wrong password", completion: nil)
                self.hideActivityIndicator()
            }
        } else {
            self.displayMessage(userMessage: "This mail does not exist", completion: nil) }
            self.hideActivityIndicator()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
           return false
       }
    
    func setPreferences(_ textField: UITextField) {
        let bottomLine = CALayer()

        bottomLine.frame = CGRect(x: 0, y: textField.frame.size.height, width: textField.frame.size.width - 30, height: 1)
        bottomLine.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 1.0).cgColor
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.layer.addSublayer(bottomLine)
    }
}
