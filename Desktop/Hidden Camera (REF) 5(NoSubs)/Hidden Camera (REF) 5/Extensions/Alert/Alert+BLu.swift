//
//  Alert+BLu.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 09.11.2023.
//

import UIKit
import CoreBluetooth

typealias HSCF_UIVIEW_CONTROLLER_HS = UIViewController

extension HSCF_UIVIEW_CONTROLLER_HS {
    public func showAlert(title:String? = nil, message: String? = nil, style: UIAlertController.Style, sender: UIView? = nil, okButtonTitle: String? = nil, cancelButtonTitle: String? = nil, okHandler: ((UIAlertAction) -> Swift.Void)? = nil, cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if okButtonTitle != nil {
            let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: okHandler)
            alert.addAction(okAction)
        }
        if cancelButtonTitle != nil {
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelHandler)
            alert.addAction(cancelAction)
        }
        
        if sender != nil {
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = (sender?.bounds)!
        }
        self.present(alert, animated: true, completion: completion)
    }
}
