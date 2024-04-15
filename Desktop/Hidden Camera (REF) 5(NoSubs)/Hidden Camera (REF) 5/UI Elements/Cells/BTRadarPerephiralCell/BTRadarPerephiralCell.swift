//
//  BTRadarPerephiralCell.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 10.11.2023.
//

import UIKit
import TinyConstraints

class BTRadarPerephiralCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.inter(.InterMedium, size: 16)
        label.textColor = .white
        label.text = "Test"
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.inter(.InterRegular, size: 12)
        label.textColor = .gray
        label.text = "Test erhthj"
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.inter(.InterRegular, size: 12)
        label.textColor = .hex("D8EB04")
        label.textAlignment = .right
        label.text = "Test erhthj"
        return label
    }()
    
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
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        contentView.addSubview(stack)
        contentView.addSubview(valueLabel)
        stack.leadingToSuperview(offset: 12)
        stack.topToSuperview(offset: 10)
        stack.bottomToSuperview(offset: -10)
        valueLabel.trailingToSuperview(offset: 12)
        valueLabel.verticalToSuperview()
        
    }
}
