//
//  AnimationSliderDevicesCell.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 13.11.2023.
//

import UIKit
import TinyConstraints
import Lottie

class AnimationSliderDevicesCell: UITableViewCell {
    var animationView: LottieAnimationView!
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews_HSCF()
        selectionStyle = .none
        backgroundColor = .cellBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews_HSCF() {
        animate_HSCF()
    }
    
    func animate_HSCF() {
        if animationView != nil {
            self.animationView.play()
        } else {
            self.animationView?.removeFromSuperview()
            self.animationView = .init(name: "Devices")
            self.animationView.frame = self.bounds
            self.animationView.contentMode = .scaleAspectFill
            self.animationView.loopMode = .loop
            self.animationView.animationSpeed = 1
            contentView.addSubview(self.animationView)
            self.animationView.play(fromProgress: 0.05, toProgress: 1.0, loopMode: .loop, completion: nil)
            animationView.edgesToSuperview()
            animationView.height(UIDevice.current.userInterfaceIdiom == .pad ? 100 : 66)
        }
    }
}
