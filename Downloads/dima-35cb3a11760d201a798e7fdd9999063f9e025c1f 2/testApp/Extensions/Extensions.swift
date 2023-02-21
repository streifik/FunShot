//
//  UIViewController+DisplayMessage.swift
//  testApp
//
//  Created by Dmitry Telpov on 10.01.23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayMessage(userMessage: String, completion: ( ()->())?)  {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: nil, message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Oк", style: .default) { (action:UIAlertAction!) in
                
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
        label.backgroundColor = UIColor(hue: 0.0778, saturation: 0, brightness: 0.74, alpha: 1.0) /* #bcbcbc */
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
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.tag = 100

        for subview in view.subviews {
          if subview.tag == 100 {
              print("already added")
              return
            }
        }
        view.addSubview(activityIndicator)
    }

      func hideActivityIndicator() {
          let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView
          activityIndicator?.stopAnimating()
          activityIndicator?.removeFromSuperview()
    }
}


extension String {
    func convertToFormattedPhoneNumber() -> String {
        let mutableString = NSMutableString(string: self)
        mutableString.insert("+(", at: 0)
        mutableString.insert(")", at: 5)
        
        return mutableString as String
    }
    
    func convertFormattedPhoneNumberToInt() -> Int  {
        let unformattedString = self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "+", with: "")
        let phoneIntFormat = Int(unformattedString) ?? 0
        
        
        return phoneIntFormat
    }
}
 
