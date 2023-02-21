//
//  RegisterViewController.swift
//  teatApp
//
//  Created by streifik on 06.12.2022.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //  MARK: Variables
      
      var name = String()
      var surname = String()
      var age = Int()
      var email = String()
      var phone = Int()
      var password = String()
      var confirmPassword = String()
      let defaultImage = UIImage(named: "defaultImage")
      var profileImage = UIImage()
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setNotifications()
        self.setTextFildDelegates()
        self.setUpUserInterface()
        //  setTextFieldsStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpUserInterface() {
        self.photoImageView.image = self.defaultImage
        self.photoImageView.layer.cornerRadius = 60
        self.navigationController?.navigationBar.backgroundColor = .white
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
        self.view.frame.origin.y = 0
        
        // check empty fields
        
        if self.nameTextField.text == "" ||
           self.surnameTextField.text == "" ||
           self.emailTextField.text == "" ||
           self.phoneNumberTextfield.text == "" ||
           self.ageTextField.text == "" ||
           self.passwordTextField.text == "" ||
           self.confirmPasswordTextField.text == "" {
            
            self.displayMessage(userMessage: "Enter all fields", completion: nil)
            
        } else {
            if let name = self.nameTextField.text {
                self.name = name
            }
            
            if let surname = self.surnameTextField.text {
                self.surname = surname
            }
            if let email = self.emailTextField.text {
                self.email = email
            }
            
            if let phone = self.phoneNumberTextfield.text {
                self.phone = phone.convertFormattedPhoneNumberToInt()
            }
            
            if let password = self.passwordTextField.text {
                self.password = password
            }
            
            if let confirmPassword = self.confirmPasswordTextField.text {
                self.confirmPassword = confirmPassword
            }
            if let image = self.photoImageView.image {
                self.profileImage = image
            }
            
            if let age = self.ageTextField.text {
                guard Int(age) != nil else {
                    self.displayMessage(userMessage: "Enter a number in the age field", completion: nil)
                    return
                }
                if let ageIntFormat = Int(age){
                    self.age = ageIntFormat
                }
            }
            
        // confirm password
            
            guard confirmPassword == password else {
                self.displayMessage(userMessage: "Passwords does not match", completion: nil)
                return
            }
            
        // check if email exist
            
            self.showActivityIndicator()
            
            if (CoreDataManager.shared.checkIfUserExist(email: self.email)) {
                self.displayMessage(userMessage: "There is an account with this email address", completion: nil)
                self.hideActivityIndicator()
            } else {
                if CoreDataManager.shared.addUser(name: self.name, surname: self.surname, email: self.email, phone: self.phone, password: self.password, age: self.age, profileImage: self.profileImage) != nil {
                    hideActivityIndicator()
                    if let loginState = CoreDataManager.shared.setLoginState(isLoggedIn: true, userEmail: email) {
                        if loginState.isLoggedIn == true {
                            if let user = CoreDataManager.shared.fetchUserData(userEmail: self.email) {
                                Settings.shared.user = user
                                self.hideActivityIndicator()
                                NavigationManager.shared.navigateToProfileViewController(sender: self)
                            }
                        } else {
                            print("Error with setting login state")
                        }
                    } else {
                        print("Error with fetching login data")
                    }
                }
            }
        }
    }
    
    func setTextFieldsStyle() {
        let textfields = [nameTextField, surnameTextField, emailTextField, ageTextField, passwordTextField, confirmPasswordTextField]
        
        for item in textfields {
            if let textfield = item {
                self.setPreferences(textfield)
            }
        }
    }
    
    func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setTextFildDelegates() {
        self.nameTextField.delegate = self
        self.surnameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneNumberTextfield.delegate = self
        self.ageTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
    
    // MARK: Keyboard methods
   
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 30
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
}

    // MARK: Delegates

extension RegisterViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.photoImageView.image = editedImage
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.photoImageView.image = originalImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
           return false
       }
    
    func setPreferences(_ textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 1.0).cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.phoneNumberTextfield) {
            
                    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                    let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)

                    let decimalString = components.joined(separator: "") as NSString
                    let length = decimalString.length
                    let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)

                    if length == 0 || (length > 11 && !hasLeadingOne) || length > 12 {
                        let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

                        return (newLength > 11) ? false : true
                    }
                    var index = 0 as Int
                    let formattedString = NSMutableString()

                    if hasLeadingOne {
                        formattedString.append("1")
                        index += 1
                    }
                    if (length - index) > 3 {
                        let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                        formattedString.appendFormat("(%@)", areaCode)
                        index += 3
                    }

                    let remainder = decimalString.substring(from: index)
                    formattedString.append(remainder)
                    textField.text = "+" + (formattedString as String)
        
                    return false
                } else {
                    return true
                }
            }
}

extension RegisterViewController: UINavigationControllerDelegate {}
