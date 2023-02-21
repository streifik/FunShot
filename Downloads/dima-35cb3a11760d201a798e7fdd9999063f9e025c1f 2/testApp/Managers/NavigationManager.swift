//
//  NavigationManager.swift
//  testApp
//
//  Created by streifik on 19.01.2023.
//

import Foundation
import UIKit
class NavigationManager {
    
static let shared = NavigationManager()
    
    func navigateToRegisterViewController(sender: UIViewController) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let editProfileViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            
        sender.show(editProfileViewController, sender: self)
        }
    }
    
    func navigateToLoginViewController(sender: UIViewController) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    if let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
        
        sender.show(loginViewController, sender: self)
        }
    }
    
    func navigateToStartPageViewController(sender: UIViewController) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    if let startVC = storyBoard.instantiateViewController(withIdentifier: "StartPageViewController") as? StartPageViewController {
        let navController = UINavigationController(rootViewController: startVC)
        navController.modalPresentationStyle = .fullScreen
        
        sender.present(navController, animated: true, completion: nil)
        }
    }

    func navigateToChatViewController(sender: UIViewController, user: User, chat: Chat) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatViewController = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            chatViewController.chat = chat
            chatViewController.user = user
            
        sender.show(chatViewController, sender: sender)
        }
    }
    
    func navigateToProfileViewController(sender: UIViewController) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let tabBar = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            sender.navigationController?.isNavigationBarHidden = true
            sender.navigationController?.pushViewController(tabBar, animated: true)
        }
    }
}
