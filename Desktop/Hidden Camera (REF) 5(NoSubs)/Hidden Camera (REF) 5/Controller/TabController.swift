//
//  Controller.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//

import UIKit

enum TabController: Int, CaseIterable {
    case scan, antiSpy, btRadar, settings
    
    var titleScene: String {
        switch self {
        case .scan: return "Scanning"
        case .antiSpy: return "Anti-spy"
        case .btRadar: return "Bluetooth"
        case .settings: return "Settings"
        }
    }
    
    var tabbarTitle: String {
        switch self {
        case .scan: return "Scan"
        case .antiSpy: return "Anti-spy"
        case .btRadar: return "BT Radar"
        case .settings: return "Settings"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .scan:
            return UIImage(named: "tab-scan")
        case .antiSpy:
            return UIImage(named: "tab-anti-spy")
        case .btRadar:
            return UIImage(named: "tab-bt-radar")
        case .settings:
            return UIImage(named: "tab-settings")
        }
    }
    
    var controllerWithTabItem: UIViewController {
        let nav = HSCFBaseNavigationController(rootViewController: controller)
        nav.navigationItem.backButtonTitle = "..."
        let icon = UITabBarItem(title: tabbarTitle, image: icon, tag: rawValue)
        nav.tabBarItem = icon
        return nav
    }
    
    var controller: UIViewController {
        var vc = UIViewController()
        switch self {
        case .scan:
            vc = HSCFScanViewController()
        case .antiSpy:
            vc = AntiSpyViewController()
        case .btRadar:
            vc = BTRadarViewController()
        case .settings:
            vc = HSCFSettingsViewController()
        }
        vc.title = titleScene
        return vc
    }
}
