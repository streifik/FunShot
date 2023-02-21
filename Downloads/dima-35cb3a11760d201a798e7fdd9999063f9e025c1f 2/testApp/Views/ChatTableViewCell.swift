//
//  ChatTableViewCell.swift
//  teatApp
//
//  Created by streifik on 08.12.2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containsImageMessagesTrailingConstraint: NSLayoutConstraint! // rename
    @IBOutlet weak var containsImagesMessagesBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containsImagesMessagesTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var noImagesMessagesTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var noImagesMessagesBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachedImageStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubleBackgroundView: UIView!
    @IBOutlet weak var bubbleRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleLeftConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    
    var blueColor = UIColor.blue
    var lightGrayColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    var containsImage: Bool! {
        didSet {
            if self.containsImage {
                self.noImagesMessagesBottomConstraint.isActive = false
                self.noImagesMessagesTrailingConstraint.isActive = false
                self.containsImageMessagesTrailingConstraint.isActive = false
                self.containsImagesMessagesBottomConstraint.isActive = true
                self.containsImagesMessagesTrailingConstraint.isActive = true
                self.containsImageMessagesTrailingConstraint.isActive = true
                self.attachedImageStackView.isHidden = false
                
                self.bubleBackgroundView.backgroundColor = .clear
                self.bubleBackgroundView.bringSubviewToFront(timeLabel)
                self.timeLabel.backgroundColor = .black
                self.timeLabel.layer.opacity = 0.7
                self.timeLabel.layer.masksToBounds = true
                self.timeLabel.layer.cornerRadius = 7
                self.timeLabel.textColor = .white
            } else {
               self.noImagesMessagesBottomConstraint.isActive = true
               self.noImagesMessagesTrailingConstraint.isActive = true
               self.containsImageMessagesTrailingConstraint.isActive = true
               self.containsImagesMessagesBottomConstraint.isActive = false
               self.containsImagesMessagesTrailingConstraint.isActive = false
               self.containsImageMessagesTrailingConstraint.isActive = false
               self.attachedImageStackView.isHidden = true
                
               self.timeLabel.textColor = self.isComing ? .gray : .white
               self.timeLabel.backgroundColor = .clear
               self.timeLabel.layer.opacity = 1
            }
        }
    }
    var isComing: Bool! {
        didSet {
            self.bubleBackgroundView.backgroundColor = self.isComing ? self.lightGrayColor : .link
            self.messageLabel.textColor = self.isComing ? .black : .white
            self.timeLabel.textColor = self.isComing ? .gray : .white
            
            if (self.isComing) {
                self.bubbleLeftConstraint.isActive = true
                self.bubbleRightConstraint.isActive = false
            } else {
                self.bubbleRightConstraint.isActive = true
                self.bubbleLeftConstraint.isActive = false
            }
        }
    }
    
    // MARK: Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.bubleBackgroundView.backgroundColor = self.lightGrayColor
        self.bubbleLeftConstraint.isActive = true
        self.bubbleRightConstraint.isActive = true
    
    }
    
    // MARK: Cell configure
    
    func configure( message: Message, userEmail: String) {
        if message.senderEmail == userEmail {
            self.isComing = false
        } else {
            self.isComing = true
        }
        
        
        if let image = message.image {
            if let img = UIImage(data: image) {
              //  self.photoImageView.image = img
                self.containsImage = true
              
            }
            
        } else {
          //  self.photoImageView.image = nil
            self.containsImage = false
        }
            
        self.messageLabel.text = message.text
        if let date =  message.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.timeLabel.text = dateFormatter.string(from: date)
        }
        
      //  self.photoImageView.layer.cornerRadius = 12
        self.bubleBackgroundView.layer.cornerRadius = 20
        self.selectionStyle = .none
    }
}
