//
//  ProfileViewController.swift
//  teatApp
//
//  Created by streifik on 06.12.2022.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController{
    
    // MARK: Outlets
    
    @IBOutlet weak var phoneDetailLabel: UILabel!
    @IBOutlet weak var nameDetailLabel: UILabel!
    @IBOutlet weak var surnameDetailLabel: UILabel!
    @IBOutlet weak var ageDetailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    // MARK: Variables
    
    var user = User()

    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Settings.shared.user {
                self.user = user
                self.setUpUserInterface()
        }
    }

    // MARK: Actions
 
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        if let loginState = CoreDataManager.shared.setLoginState(isLoggedIn: false, userEmail: nil) {
            Settings.shared.user = nil 
            if loginState.isLoggedIn == false {
                NavigationManager.shared.navigateToStartPageViewController(sender: self)
            } else {
                print("error with setting login state")
            }
        } else {
            print("error with fetching login state")
        }
    }
    
    // MARK: FillData
    
    func setUpUserInterface() {

        self.avatarImageView.layer.cornerRadius = 55
        
        if let userName = self.user.value(forKey: "name") as? String {
            self.nameDetailLabel.text = userName
        }
        if let userSurname = self.user.value(forKey: "surname") as? String {
            self.surnameDetailLabel.text = userSurname
        }
        
        if let userAge = self.user.value(forKey: "age") as? Int {
            self.ageDetailLabel.text = String(userAge)
        }
        if let userPhone = self.user.value(forKey: "phone") as? Int {
            let phoneStringFormat = String(userPhone)
            self.phoneDetailLabel.text = phoneStringFormat.convertToFormattedPhoneNumber()
        }
        
        if let userImageData = self.user.value(forKey: "profileImage") as? Data {
            if userImageData.isEmpty == false {
                self.avatarImageView.image = UIImage(data: userImageData)
            }
        }
    }
}

