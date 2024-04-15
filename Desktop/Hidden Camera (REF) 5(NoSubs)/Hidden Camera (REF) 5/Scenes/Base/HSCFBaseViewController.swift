//
//  BaseViewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//

import UIKit

class HSCFBaseViewController: UIViewController {
    
    private var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        navigationItem.backButtonTitle = ""
        NotificationCenter.default.addObserver(self, selector: #selector(internerConntectionHandle), name: .connectivityStatus, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self is HSCFSettingsViewController || self is HSCFScanViewController || self is AntiSpyViewController || self is BTRadarViewController {
            tabbarView?.isHidden = false
        } else {
            UIView.animate(withDuration: 0.3) {
                tabbarView?.isHidden = true
            }
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc
    func internerConntectionHandle() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if HSCFNetworkMonitor.shared.isConnected {
                if let alert {
                    alert.dismiss(animated: true)
                    self.alert = nil
                }
            } else {
                if alert == nil {
                    self.alert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
                    self.present(self.alert!, animated: true)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

private func swizzle(
    targetClass: AnyClass,
    originalSelector: Selector,
    swizzledSelector: Selector
) {
    let originalMethod = class_getInstanceMethod(targetClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(targetClass, swizzledSelector)
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

extension UIViewController {
    
    static let classInit: Void = {
        let originalSelector = #selector(viewWillAppear(_:))
        let swizzledSelector = #selector(swizzledViewWillAppear(_:))
        swizzle(
            targetClass: UIViewController.self,
            originalSelector: originalSelector,
            swizzledSelector: swizzledSelector
        )
    }()
    
    /// Hides the iOS 14 navigation menu (shown on a long press on any back
    /// button).
    ///
    /// More details at:
    /// https://sarunw.com/posts/what-should-you-know-about-navigation-history-stack-in-ios14/
    @objc func swizzledViewWillAppear(_ animated: Bool) {
        if #available(iOS 14.0, *) {
            let backButton = BackBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem = backButton
        }
        // Call the original viewWillAppear
        swizzledViewWillAppear(animated)
    }
}

class BackBarButtonItem: UIBarButtonItem {
    @available(iOS 14.0, *)
    override var menu: UIMenu? {
        get {
            return super.menu
        }
        set {
            // Don't set the menu here
            // super.menu = menu
        }
    }
}
