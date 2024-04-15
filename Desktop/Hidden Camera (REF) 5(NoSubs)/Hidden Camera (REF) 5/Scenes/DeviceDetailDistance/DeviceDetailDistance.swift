//
//  DeviceDetailDistance.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 13.11.2023.
//

import UIKit
import TinyConstraints
import Lottie

class DeviceDetailDistanceViewController: HSCFBaseViewController {
    
    // MARK: - UIProperties
    private lazy var radarView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var distanceView: UIView = {
       let v = UIView()
        v.backgroundColor = .clear
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.hex("333333").cgColor
        return v
    }()
    
    private lazy var distanceLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.inter(.InterMedium, size: 16)
        lbl.textColor = UIColor.greenLabel
        lbl.text = "Loading..."
        return lbl
    }()
    
    private lazy var alertView: UIView = {
       let v = UIView()
        v.backgroundColor = UIColor.cellBackground
        v.layer.cornerRadius = 12
        return v
    }()
    
    private lazy var alertLabel: UIView = {
       let lbl = UILabel()
        lbl.font = UIFont.inter(.InterRegular, size: 16)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 12
        lbl.textColor = UIColor.hex("898787")
        lbl.text = "Move to strengthen the signal"
        return lbl
    }()
    
    // MARK: - Properties
    public var name: String?
    public var rssi: Int? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.distanceLabel.text = "Distance: \(self?.rssi ?? 0) m"
            }
        }
    }
    
    lazy var bluService = BLUService()
    private var animationView: LottieAnimationView!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSubviews()
        if let name {
            self.title = name
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animateRadar()
    }
    
    private func prepareSubviews() {
        view.addSubview(radarView)
        radarView.topToSuperview(offset: 40, usingSafeArea: true)
        radarView.leftToSuperview(offset: 33, usingSafeArea: true)
        radarView.rightToSuperview(offset: -33, usingSafeArea: true)
        radarView.aspectRatio(1)
        
        view.addSubview(distanceView)
        distanceView.topToBottom(of: radarView, offset: 16)
        distanceView.leftToSuperview(offset: 20)
        
        distanceView.addSubview(distanceLabel)
        distanceLabel.topToSuperview(offset: 10)
        distanceLabel.leadingToSuperview(offset: 20)
        distanceLabel.trailingToSuperview(offset: 20)
        distanceLabel.bottomToSuperview(offset: -10)
        
        view.addSubview(alertView)
        alertView.topToBottom(of: distanceView, offset: 16)
        alertView.leadingToSuperview(offset: 20)
        alertView.trailingToSuperview(offset: 20)
        
        alertView.addSubview(alertLabel)
        alertLabel.topToSuperview(offset: 10)
        alertLabel.leadingToSuperview(offset: 20)
        alertLabel.trailingToSuperview(offset: 20)
        alertLabel.bottomToSuperview(offset: -10)
    }
    
    private func animateRadar() {
        if animationView != nil {
            self.animationView.play()
        } else {
            self.animationView?.removeFromSuperview()
            self.animationView = .init(name: "Radar")
            self.animationView.frame = self.radarView.bounds
            self.animationView.contentMode = .scaleAspectFill
            self.animationView.loopMode = .loop
            self.animationView.animationSpeed = 0.5
            self.animationView.layer.cornerRadius = self.radarView.frame.height / 2
            self.radarView.addSubview(self.animationView)
            self.animationView.play()
        }
    }
}
