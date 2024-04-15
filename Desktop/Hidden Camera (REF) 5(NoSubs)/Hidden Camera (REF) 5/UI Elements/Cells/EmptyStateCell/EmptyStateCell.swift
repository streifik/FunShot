//
//  EmptyStateCell.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 15.11.2023.
//

import UIKit
import TinyConstraints

class EmptyStateCell: UITableViewCell {
    // MARK: - UIProperties
    lazy var imgView = UIImageView(image: UIImage.init(named: "empty-state-icon"))
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.inter(.InterRegular, size: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Empty"
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews_HSCF()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews_HSCF() {
        contentView.addSubview(imgView)
        imgView.height(80)
        imgView.width(80)
        imgView.topToSuperview(offset: 90)
        imgView.centerXToSuperview()
        
        contentView.addSubview(titleLabel)
        titleLabel.topToBottom(of: imgView, offset: 10)
        titleLabel.leadingToSuperview(offset: 71)
        titleLabel.trailingToSuperview(offset: 71)
        titleLabel.bottomToSuperview(offset: -90)
    }
}
