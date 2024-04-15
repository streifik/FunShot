//
//  TabBarViewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//

import UIKit
import TinyConstraints

var tabbarView: UIView!
var tabController: GSDA_ContainerForTabbarController_GSD?

final class HTSP_TabItem_View: UIView {
    
    lazy var buttonAction: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        return button
    }()
    lazy var tabImage: UIImageView = {
        let imgView = UIImageView()
        imgView.tintColor = UIColor.hex("898787")
        return imgView
    }()
    lazy var tabTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.inter(.InterRegular, size: 10)
        label.textAlignment = .center
        label.textColor = UIColor.hex("898787")
        return label
    }()
    lazy var shadowImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "tab-shadow")
        imgView.isHidden = true
        return imgView
    }()
    
    var actionCompletion: (() -> Void)?
    var controller: TabController?
    
    init(controller: TabController) {
        super.init(frame: .zero)
        self.controller = controller
        setupSubviews()
        tabTitle.text = controller.tabbarTitle
        tabImage.image = controller.icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSelect(_ isSelect: Bool) {
        tabImage.tintColor = isSelect ? UIColor.hex("D8EB04") : UIColor.hex("898787")
        tabTitle.textColor = isSelect ? UIColor.hex("D8EB04") : UIColor.hex("898787")
        shadowImageView.isHidden = !isSelect
    }
    
    private func setupSubviews() {
        tabTitle.text = "asde"
        
        addSubview(shadowImageView)
        shadowImageView.height(50)
        shadowImageView.width(50)
        
        addSubview(tabImage)
        tabImage.height(30)
        tabImage.width(30)
        
        shadowImageView.centerY(to: tabImage)
        shadowImageView.centerX(to: tabImage)
        
        tabImage.topToSuperview()
        tabImage.centerXToSuperview()
        
        addSubview(tabTitle)
        tabTitle.topToBottom(of: tabImage, offset: 4)
        tabTitle.leftToSuperview()
        tabTitle.rightToSuperview()
        tabTitle.bottomToSuperview()
        tabTitle.height(12)
        
        addSubview(buttonAction)
        buttonAction.edgesToSuperview()
    }
    
    @objc
    func actionTapped() {
        actionCompletion?()
    }
}

final class GSDA_ContainerForTabbarController_GSD: UIViewController {
    private lazy var tab_m_tabbarController = TabBarViewController()
    private let containerView = UIView()
    private let tabbarMenuContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tabbarBackground
        return view
    }()
    private var tabbarMenuView: UIView = UIView()
    
    private var scan: HTSP_TabItem_View = HTSP_TabItem_View(controller: .scan)
    private var antiSpy: HTSP_TabItem_View = HTSP_TabItem_View(controller: .antiSpy)
    private var btRadar: HTSP_TabItem_View = HTSP_TabItem_View(controller: .btRadar)
    private var settings: HTSP_TabItem_View = HTSP_TabItem_View(controller: .settings)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabController = self
        setupSubviews()
        scan.actionCompletion = { [weak self] in self?.actionTapped(controller: .scan) }
        antiSpy.actionCompletion = { [weak self] in self?.actionTapped(controller: .antiSpy) }
        btRadar.actionCompletion = { [weak self] in self?.actionTapped(controller: .btRadar) }
        settings.actionCompletion = { [weak self] in self?.actionTapped(controller: .settings) }
        scan.isSelect(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tab_m_tabbarController.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UserDefaults.termsOfServiceAlertIsShowed {
            HSCFAlertView.instance.showAlert_HSCF(title: "Terms of Service and Privacy Policy", message: "Welcome! We are dedicated to ensuring the privacy of your information. Our Terms of Service and Privacy Policy offer detailed information on data collection and usage. By clicking ‘Accept’ below, you affirm your consent to our Terms of Service and understanding of the Privacy Policy.", leftActionTitle: "Accept", rightActionTitle: nil) {
                UserDefaults.termsOfServiceAlertIsShowed = true
            } rightAction: { }
        }
    }
    
    public func processOpeningScanSceneAndScanning() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.actionTapped(controller: .scan)
            let vc: HSCFScanViewController? = self?.tab_m_tabbarController.getViewController(controller: .scan)
            vc?.tryStartScan()
        }
    }
    
    private func setupSubviews() {
        
        let mainStackView = UIStackView(arrangedSubviews: [containerView, tabbarMenuContainer])
        mainStackView.axis = .vertical
        view.addSubview(mainStackView)
        mainStackView.edgesToSuperview()
        
        tabbarMenuContainer.addSubview(tabbarMenuView)
        tabbarMenuView.topToSuperview()
        tabbarMenuView.bottomToSuperview(usingSafeArea: true)
        tabbarMenuView.leftToSuperview()
        tabbarMenuView.rightToSuperview()
        tabbarMenuView.height(64)
        
        
        addChild(tab_m_tabbarController)
        containerView.addSubview(tab_m_tabbarController.view)
        tab_m_tabbarController.view.edgesToSuperview()
        
        let stackView = UIStackView(arrangedSubviews: [scan, antiSpy, btRadar, settings])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        tabbarMenuView.addSubview(stackView)
        stackView.leftToSuperview()
        stackView.rightToSuperview()
        stackView.centerYToSuperview()
        
        tabbarView = tabbarMenuContainer
    }
    
    private func actionTapped(controller: TabController) {
        switch controller {
        case .scan:
            tab_m_tabbarController.selectTab(controller: .scan)
        case .antiSpy:
                tab_m_tabbarController.selectTab(controller: .antiSpy)
        case .btRadar:
                tab_m_tabbarController.selectTab(controller: .btRadar)
        case .settings:
            tab_m_tabbarController.selectTab(controller: .settings)
        }
        
        scan.isSelect(controller == .scan)
        antiSpy.isSelect(controller == .antiSpy)
        btRadar.isSelect(controller == .btRadar)
        settings.isSelect(controller == .settings)
    }
}

class TabBarViewController: UITabBarController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = TabController.allCases.map { $0.controllerWithTabItem }
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func selectTab(controller: TabController) {
        selectedIndex = controller.rawValue
    }
    
    public func getViewController<T>(controller: TabController) -> T? {
        
        func vc(nav: UIViewController) -> UIViewController {
            (nav as! UINavigationController).viewControllers.first!
        }
        
        switch controller {
        case .scan:
            let nav = viewControllers?.first(where: { vc(nav: $0) is HSCFScanViewController }) as? UINavigationController
            return nav?.viewControllers.first as? T
        case .antiSpy:
            let nav = viewControllers?.first(where: { vc(nav: $0) is AntiSpyViewController }) as? UINavigationController
            return nav?.viewControllers.first as? T
        case .btRadar:
            let nav = viewControllers?.first(where: { vc(nav: $0) is BTRadarViewController }) as? UINavigationController
            return nav?.viewControllers.first as? T
        case .settings:
            let nav = viewControllers?.first(where: { vc(nav: $0) is HSCFSettingsViewController }) as? UINavigationController
            return nav?.viewControllers.first as? T
        }
    }
}

