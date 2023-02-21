//
//  StartPageViewController.swift
//  teatApp
//
//  Created by streifik on 06.12.2022.
//

import UIKit

class StartPageViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConstraints()
    }
    
    // MARK: Actions
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        NavigationManager.shared.navigateToRegisterViewController(sender: self)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        NavigationManager.shared.navigateToLoginViewController(sender: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.setConstraints()
    }
    
    func setConstraints() {
        if UIDevice.current.orientation.isLandscape {
            self.logoTopConstraint.constant = 40
        } else {
            self.logoTopConstraint.constant = 170
        }
    }
}
