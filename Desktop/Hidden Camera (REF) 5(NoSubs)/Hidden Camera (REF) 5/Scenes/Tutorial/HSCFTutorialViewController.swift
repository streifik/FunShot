//
//  TutorialViewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 13.11.2023.
//

import UIKit
import TinyConstraints

class HSCFTutorialViewController: HSCFBaseViewController {
    
    // MARK: - UIProperties
    private lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.cellBackground
        v.layer.cornerRadius = 16
        return v
    }()
    private lazy var scrollView = UIScrollView()
    private lazy var bookImageView = UIImageView(image: UIImage(named: "book"))
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.inter(.InterMedium, size: 16)
        lbl.textColor = .white
        lbl.text = "Tactics for Shooting Against an Ambush"
        lbl.textAlignment = .center
        return lbl
    }()
    private lazy var textLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.inter(.InterRegular, size: 14)
        lbl.numberOfLines = 0
        lbl.textColor = .hex("898787")
        lbl.text = "1. Check whether covert cameras are installed in televisions, light fixtures, wall gaps, fire alarms, sockets, etc., as well as whether the bathroom glass is transparent.\n\n2. Dim the lighting in the room or turn off the power when the card is removed. Capturing a clear photo of the camera lens under normal room brightness is challenging; a power outage serves as a better safeguard. The camera's energy consumption is relatively high. Typically, the power source in a hotel room is connected to the network. The camera will naturally cease functioning when the entire room's power is switched off. Some hidden cameras may emit a small, predominantly red, bright light during operation. After turning off the entire room's power, neglected flashlights are easier to locate in the darkness.\n\n3. Close doors and windows and draw the curtains. The initial steps are aimed at preventing monitoring within the room; however, external factors cannot be ignored.\n\n4. Be vigilant to ensure you're not being followed by others. Do not open the door to strangers willingly (refrain from sales, door-to-door services at unknown times, etc.), and lock the internal door when you're sleeping.\n\n5. Choose a hotel with a good reputation. The likelihood of being monitored in a small, obscure hotel is significantly higher than in a regular hotel, as regular hotels undergo more stringent checks."
        return lbl
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews_HSCF()
    }
    
    private func setupSubviews_HSCF() {
        
        view.addSubview(containerView)
        containerView.topToSuperview(offset: 20, usingSafeArea: true)
        containerView.leadingToSuperview(offset: 20)
        containerView.trailingToSuperview(offset: 20)
        containerView.bottomToSuperview(offset: -20)
        
        let stackView = UIStackView(arrangedSubviews: [bookImageView, titleLabel, textLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.topToSuperview(offset: 12)
        scrollView.leftToSuperview(offset: 12)
        scrollView.rightToSuperview(offset: -12)
        scrollView.bottomToSuperview(offset: -12)
        
        stackView.edgesToSuperview()
        stackView.centerXToSuperview()
        
        bookImageView.height(40)
        bookImageView.width(40)
    }
}
