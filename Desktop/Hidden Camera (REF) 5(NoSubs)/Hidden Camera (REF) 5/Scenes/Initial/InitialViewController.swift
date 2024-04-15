//
//  InitialViewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//

import UIKit

class InitialViewController: HSCFBaseViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNextScene()
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    private func showNextScene() {
         let scanVC = HSCFScanViewController()
         
         // Set navigation bar title color
         let navController = UINavigationController(rootViewController: scanVC)
       
         navController.modalPresentationStyle = .fullScreen
         navController.modalTransitionStyle = .crossDissolve
         
         present(navController, animated: true)
     }
}
