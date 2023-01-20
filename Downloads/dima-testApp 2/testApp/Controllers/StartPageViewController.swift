//
//  StartPageViewController.swift
//  teatApp
//
//  Created by streifik on 06.12.2022.
//

import UIKit

class StartPageViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    
    // MARK: Actions
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        NavigationManager.shared.navigateToRegisterViewController(sender: self)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        NavigationManager.shared.navigateToLoginViewController(sender: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
          super.viewWillTransition(to: size, with: coordinator)
        
          if UIDevice.current.orientation.isLandscape {
              logoHeightConstraint.constant = 50
          } else {
              logoHeightConstraint.constant = 170
        }
    }
}
