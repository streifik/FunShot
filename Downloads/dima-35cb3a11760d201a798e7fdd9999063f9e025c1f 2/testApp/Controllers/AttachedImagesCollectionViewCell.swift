//
//  AttachedImagesCollectionViewCell.swift
//  testApp
//
//  Created by Dmitry Telpov on 16.02.23.
//

import UIKit

class AttachedImagesCollectionViewCell: UICollectionViewCell {
    var delegate: AttachedImagesCollectionViewCellDelegate?
    
    var imageIndex = Int()
    
    @IBOutlet weak var attachedImageView: UIImageView!
    @IBAction func closeButtonTapped(_ sender: UIButton) {

        delegate?.closeButtonTapped(index: self.imageIndex )
        
    }
    
}
protocol AttachedImagesCollectionViewCellDelegate {
    func closeButtonTapped(index: Int)
}
