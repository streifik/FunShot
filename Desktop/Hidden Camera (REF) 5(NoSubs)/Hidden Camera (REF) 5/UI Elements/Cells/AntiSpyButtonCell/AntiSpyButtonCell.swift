//
//  AntiSpyButtonCell.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 14.12.2023.
//

import UIKit
import TinyConstraints

class AntiSpyButtonCell: UITableViewCell {
    
    private lazy var button: UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.hex("D8EB04")
        b.titleLabel?.font = UIFont.inter(.InterMedium, size: 18)
        b.setTitle("Scan the network", for: .normal)
        b.setTitleColor(UIColor.hex("121212"), for: .normal)
        b.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        return b
    }()
    
    public var actionCompletion: (() -> ())?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews_HSCF33()
        selectionStyle = .none
        backgroundColor = .cellBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func actionTapped() {
        actionCompletion?()
    }
    
    private func setupSubviews_HSCF33() {
        contentView.addSubview(button)
        button.edgesToSuperview()
        button.height(43)
    }
}
