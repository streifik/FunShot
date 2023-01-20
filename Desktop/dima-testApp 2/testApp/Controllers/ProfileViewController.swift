//
//  ProfileViewController.swift
//  teatApp
//
//  Created by streifik on 06.12.2022.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController{
    
    // MARK: Variables
    
    var user = User()

    // MARK: Outlets
    
    @IBOutlet weak var nameDetailLabel: UILabel!
    @IBOutlet weak var surnameDetailLabel: UILabel!
    @IBOutlet weak var ageDetailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    

    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        avatarImageView.layer.cornerRadius = 55
        fillData()
        }

    // MARK: Actions
 
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        NavigationManager.shared.navigateToStartPageViewController(sender: self)
        }
    
    // MARK: FillData
    
    func fillData() {
        navigationController?.navigationBar.prefersLargeTitles = true
        avatarImageView.layer.cornerRadius = 55
        
        if let userName = user.value(forKey: "name") as? String{
            nameDetailLabel.text = userName
        }
        if let userSurname = user.value(forKey: "surname") as? String{
            surnameDetailLabel.text = userSurname
        }
        
        if let userAge = user.value(forKey: "age") as? Int{
            ageDetailLabel.text = String(userAge)
        }
        
        if let userImageData = user.value(forKey: "profileImage") as? Data{
            if userImageData.isEmpty == false {
                avatarImageView.image = UIImage(data: userImageData)
            }
        }
    }
}
  
