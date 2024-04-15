//
//  AntiSpyDetailsCell.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 14.11.2023.
//

import UIKit
import TinyConstraints

class AntiSpyDetailsCell: UITableViewCell {
    
    // MARK: - UIProperties
    lazy var imgView = UIImageView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.inter(.InterMedium, size: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Test"
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.inter(.InterRegular, size: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
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
        
        
        contentView.addSubview(imgView)
        imgView.height(40)
        imgView.width(40)
        imgView.topToSuperview(offset: 12)
        imgView.centerXToSuperview()
        
        contentView.addSubview(titleLabel)
        titleLabel.topToBottom(of: imgView, offset: 10)
        titleLabel.leadingToSuperview(offset: 11)
        titleLabel.trailingToSuperview(offset: 11)
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.topToBottom(of: titleLabel, offset: 8)
        subtitleLabel.leadingToSuperview(offset: 11)
        subtitleLabel.trailingToSuperview(offset: 11)
        subtitleLabel.bottomToSuperview(offset: -12)
    }
}
