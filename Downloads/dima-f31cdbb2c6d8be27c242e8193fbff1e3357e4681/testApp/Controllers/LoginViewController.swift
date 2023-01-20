//
//  LoginViewController.swift
//  teatApp
//
//  Created by streifik on 06.12.2022.
//
import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    // MARK: Variables
    
    var email = String()
    var password = String()
    var user = User()
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: Actions
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        
        // check empty fields
        
        if emailTextField.text == "" ||
           passwordTextField.text == "" {
           displayMessage(userMessage: "Enter all fields", completion: nil)
            
        } else {
            if let email = emailTextField.text {
                self.email = email
            }
            
            if let password = passwordTextField.text {
                self.password = password
            }
            
        // check data in CoreData
        
        if CoreDataManager.shared.checkIfUserExist(email: email) == true {
            if CoreDataManager.shared.checkIfPasswordMatch(email: email, password: password) == true {
                if let user = CoreDataManager.shared.fetchUserData(userEmail: email) {
                    NavigationManager.shared.navigateToProfileViewController(sender: self, user: user)
                }
            } else {
                displayMessage(userMessage: "Wrong password", completion: nil)
            }
        } else {
            displayMessage(userMessage: "This mail does not exist", completion: nil) }
        }
    }
}
