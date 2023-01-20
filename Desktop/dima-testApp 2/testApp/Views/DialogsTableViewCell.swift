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
    
        nameLabel.text = chat.user?.name
        messageLabel.text = chat.lastMessage
       
        if let date =  chat.lastMessageDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                timeLabel.text = dateFormatter.string(from: date)
            }
        
        
        if let userImageData = chat.user?.profileImage {
            if userImageData.isEmpty == false {
                avatarImageView.image = UIImage(data: userImageData)
                }
            } else {
                avatarImageView.image = UIImage(named: "defaultImage")
            }
            
            avatarImageView.layer.cornerRadius = 27.5
            selectionStyle = .none
    }
}


