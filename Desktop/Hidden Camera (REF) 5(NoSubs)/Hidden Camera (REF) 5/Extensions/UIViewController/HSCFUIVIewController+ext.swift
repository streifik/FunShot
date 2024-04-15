//
//  UIVIewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 14.11.2023.
//

import UIKit

extension HSCF_UIVIEW_CONTROLLER_HS {
    func pushViewControllerHSCF(_ controller: Controller_HSCF, animated: Bool) {
        navigationController?.pushViewController(controller.controller, animated: animated)
    }
    
    func presentHSCF(_ controller: Controller_HSCF, animated: Bool, completion: (() -> Void)? = nil) {
        present(controller.controller, animated: animated, completion: completion)
    }
}
