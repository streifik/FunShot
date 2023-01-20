//
//  UIViewController+DisplayMessage.swift
//  testApp
//
//  Created by Dmitry Telpov on 10.01.23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayMessage(userMessage:String, completion: ( ()->())?)  {
    DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: nil, message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Oк", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
              
                DispatchQueue.main.async
                    {
                        print("Ok button tapped")
                        completion?()
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            }
        }
    
    func createMessageLabel(text: String ) -> (UILabel) {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.6, height: view.frame.height * 0.05))
        label.backgroundColor = UIColor.lightGray
        label.textColor = UIColor.white
        label.font = label.font.withSize(14)
        label.center = view.center
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        
     return label
    }
}

