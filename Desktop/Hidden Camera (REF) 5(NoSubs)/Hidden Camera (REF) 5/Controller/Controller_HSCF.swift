//
//  Controller.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 09.11.2023.
//

import UIKit

enum Controller_HSCF {
    case scanDetails
    case tutorial
    case deviceDetailDistance
    case antiSpyDetail
    
    var titleScene: String {
        switch self {
        case .scanDetails: return "Details"
        case .tutorial: return "Tutorial"
        case .deviceDetailDistance: return "Device"
        case .antiSpyDetail: return "Details"
        }
    }
    
    var controller: UIViewController {
        var vc = UIViewController()
        switch self {
        case .scanDetails:
            vc = ScanDetailsViewController()
        case .tutorial:
            vc = HSCFTutorialViewController()
        case .deviceDetailDistance:
            vc = DeviceDetailDistanceViewController()
        case .antiSpyDetail:
            vc = AntiSpyDetailsViewController()
        }
        vc.title = titleScene
//        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}
