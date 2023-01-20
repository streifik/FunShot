//
//  RegisterViewController.swift
//  teatApp
//
//  Created by streifik on 06.12.2022.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

  //  MARK: Variables
    
    var name = String()
    var surname = String()
    var age = Int()
    var password = String()
    var confirmPassword = String()
    var email = String()
    let defaultImage = UIImage(named: "defaultImage")
    var profileImage = UIImage()
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNotifications()
        setTextFildDelegates()
        
        photoImageView.image = defaultImage
        photoImageView.layer.cornerRadius = 60
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Actions
    
    @IBAction func selectPhotoButtonTapped(_ sender: UIButton) {
        let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
             
            self.present(image, animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        view.frame.origin.y = 0
        
        // check empty fields
        
        if nameTextField.text == "" ||
           surnameTextField.text == "" ||
           emailTextField.text == "" ||
           ageTextField.text == "" ||
           passwordTextField.text == "" ||
           confirmPasswordTextField.text == "" {
            
            displayMessage(userMessage: "Enter all fields", completion: nil)
            
        } else {
            if let name = nameTextField.text {
                self.name = name
            }
            
            if let surname = surnameTextField.text {
                self.surname = surname
            }
            if let email = emailTextField.text {
                self.email = email
            }
            
            if let password = passwordTextField.text {
                self.password = password
            }
            
            if let confirmPassword = confirmPasswordTextField.text {
                self.confirmPassword = confirmPassword
            }
            if let image = photoImageView.image {
                self.profileImage = image
            }
            
        // check if ageTextfield contains Int
            
            if let age = ageTextField.text {
                guard Int(age) != nil else {
                    displayMessage(userMessage: "Enter a number in the age field", completion: nil)
                    return
                }
                if let ageIntFormat = Int(age){
                    self.age = ageIntFormat
                }
            }
            
        // confirm password
            
            guard confirmPassword == password else {
                displayMessage(userMessage: "Passwords does not match", completion: nil)
                return
            }
            
        // check if email exist
    
            if CoreDataManager.shared.checkIfUserExist(email: email) == true {
                displayMessage(userMessage: "There is an account with this email address", completion: nil)
            } else {
                if let user = CoreDataManager.shared.addUser(name: name, surname: surname, email: email, password: password, age: age, profileImage: profileImage) {
                    NavigationManager.shared.navigateToProfileViewController(sender: self, user: user)
                }
            }
        }
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setTextFildDelegates() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        emailTextField.delegate = self
        ageTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    // MARK: Keyboard methods
   
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 35
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

    // MARK: Delegates

extension RegisterViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            photoImageView.image = editedImage
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            photoImageView.image = originalImage
            picker.dismiss(animated: true, completion: nil)
            }
        }
    }

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
           return false
       }
    }

extension RegisterViewController: UINavigationControllerDelegate {}
