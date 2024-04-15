//
//  ScanDetailLanDeviceCell.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 15.11.2023.
//

import UIKit
import TinyConstraints

class ScanDetailLanDeviceCell: UITableViewCell {
    
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
    
    lazy var rightImageView: UIImageView = {
       let img = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        img.tintColor = UIColor.hex("E73F3F")
        return img
    }()
    
    lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .cellBackground
        v.layer.cornerRadius = 8
        return v
    }()
    
    func of_setup_st_ate_RIGHT_image(showCheckMark: Bool) {
        rightImageView.image = showCheckMark ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "exclamationmark.triangle.fill")
        rightImageView.tintColor = showCheckMark ? .green.withAlphaComponent(0.7) : UIColor.hex("E73F3F")
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews_HSCF()
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews_HSCF() {
        contentView.addSubview(containerView)
        containerView.topToSuperview(offset: 6)
        containerView.leadingToSuperview(offset: 20)
        containerView.trailingToSuperview(offset: 20)
        containerView.bottomToSuperview(offset: -6)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        containerView.addSubview(stack)
        
        stack.leadingToSuperview(offset: 12)
        stack.topToSuperview(offset: 10)
        stack.bottomToSuperview(offset: -10)
        
        containerView.addSubview(rightImageView)
        
        rightImageView.rightToSuperview(offset: -12)
        rightImageView.centerYToSuperview()
        rightImageView.height(24)
        rightImageView.width(24)
    }
}
