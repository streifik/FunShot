//
//  ScanDetailCell.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 09.11.2023.
//

import UIKit

class ScanDetailCell: UITableViewCell {
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var titleValueButton: UIButton!
    
    @IBOutlet weak var subTitleTextLabel: UILabel!
    @IBOutlet weak var subTitleValueLabel: UILabel!
    
    var actionTapped: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        setup()
    }
    
    private func setup() {
        titleTextLabel.font = UIFont.inter(.InterMedium, size: 16)
        [subTitleTextLabel, subTitleValueLabel].forEach { $0.font = UIFont.inter(.InterRegular, size: 12) }
        titleValueButton.titleLabel?.font = UIFont.inter(.InterRegular, size: 14)
        contentView.backgroundColor = UIColor.cellBackground
        selectionStyle = .none
    }
    
    @IBAction func my_actionTapped_rudk_hpsd(_ sender: UIButton) {
        actionTapped?()
    }
}
