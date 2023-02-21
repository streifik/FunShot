//
//  LaunchScreenViewController.swift
//  testApp
//
//  Created by Dmitry Telpov on 09.02.23.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let loginState = CoreDataManager.shared.checkIfUserLoggedIn() {
            if (loginState.isLoggedIn) {
                if let userEmail = loginState.userEmail {
                    if let user = CoreDataManager.shared.fetchUserData(userEmail: userEmail) {
                        Settings.shared.user = user
                        NavigationManager.shared.navigateToProfileViewController(sender: self)
                    }
                }
            } else {
                NavigationManager.shared.navigateToStartPageViewController(sender: self)
            }
        } else {
            NavigationManager.shared.navigateToStartPageViewController(sender: self)
        }
    }
}
