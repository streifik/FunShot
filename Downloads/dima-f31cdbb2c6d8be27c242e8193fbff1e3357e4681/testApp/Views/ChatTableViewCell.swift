//
//  ChatTableViewCell.swift
//  teatApp
//
//  Created by streifik on 08.12.2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    // MARK: Variables
  
    var blueColor = UIColor.blue
    var lightGrayColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    var isComing: Bool! {
        
        didSet {
            bubleBackgroundView.backgroundColor = isComing ? lightGrayColor : blueColor
            messageLabel.textColor = isComing ? .black : .white
            timeLabel.textColor = isComing ? .gray : lightGrayColor

            if (isComing == true){
                timeLabelToBubbleViewTrailingConstraint.isActive = true
                messageLabelLedingConstraint.isActive = true
                timeLabelToContentviewTrailingConstraint.isActive = false
            } else {
                messageLabelLedingConstraint.isActive = false
                timeLabelToContentviewTrailingConstraint.isActive = true
                timeLabelToBubbleViewTrailingConstraint.isActive = false
            }
        }
    }

    // MARK: Outlets
    
    @IBOutlet weak var timeLabelToBubbleViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabelToContentviewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabelLedingConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubleBackgroundView: UIView!
    
    // MARK: Cell configure
    
    func configure( message: Message, userEmail: String) {
        messageLabel.text = message.text
        
        if message.senderEmail == userEmail {
            isComing = false
        } else {
           isComing = true
        }
        
        if let date =  message.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
          timeLabel.text = dateFormatter.string(from: date)
        }
        
      bubleBackgroundView.layer.cornerRadius = 21
      selectionStyle = .none
    }
}
