//
//  DialogsTableViewCell.swift
//  teatApp
//
//  Created by streifik on 08.12.2022.
//

import UIKit

class DialogsTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func configure(chat: Chat) {
    
        self.nameLabel.text = chat.user?.name
        if chat.lastMessage == nil {
            self.messageLabel.text = "Image"
        } else {
            self.messageLabel.text = chat.lastMessage
        }
       
        if let date =  chat.lastMessageDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.timeLabel.text = dateFormatter.string(from: date)
            }
        
        
        if let userImageData = chat.user?.profileImage {
            if userImageData.isEmpty == false {
                self.avatarImageView.image = UIImage(data: userImageData)
                }
            } else {
                self.avatarImageView.image = UIImage(named: "defaultImage")
            }
        
            self.avatarImageView.layer.cornerRadius = 27.5
            self.selectionStyle = .none
    }
}


