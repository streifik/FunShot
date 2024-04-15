//
//  CBManagerState+AlertTitles.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 09.11.2023.
//

import UIKit
import CoreBluetooth

typealias CB_HSCF_MANGAER_STATE = CBManagerState

extension CB_HSCF_MANGAER_STATE {
    var alertTitle: String {
        switch self {
        case .unknown:
            return "unknown"
        case .resetting:
            return "Resetting"
        case .unsupported:
            return "Unsupported"
        case .unauthorized:
            return "Unauthorized"
        case .poweredOff:
            return "Powered Off"
        case .poweredOn:
            return "Powered On"
        @unknown default:
            return "unknown"
        }
    }
    
    var alertSubtitle: String {
        switch self {
        case .unknown:
            return ""
        case .resetting:
            return "Try again later"
        case .unsupported:
            return ""
        case .unauthorized:
            return "You need to give access to Bluetooth in the settings in order to start scanning"
        case .poweredOff:
            return "You need to enable bluetooth in your phone settings"
        case .poweredOn:
            return ""
        @unknown default:
            return "unknown"
        }
    }
    
    var alertActionTitle: String {
        switch self {
        case .unknown:
            return "Ok"
        case .resetting:
            return "Ok"
        case .unsupported:
            return "Ok"
        case .unauthorized:
            return "Open settings"
        case .poweredOff:
            return "Open settings"
        case .poweredOn:
            return "Ok"
        @unknown default:
            return "OK"
        }
    }
    
    func action() {
        switch self {
        case .unauthorized, .poweredOff:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        default:
            break
        }
    }
}
