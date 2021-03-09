//
//  StickerListCVCell.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import UIKit

class StickerListCVCell: UICollectionViewCell {
    //Sticker를 보여주기 위한 Cell
    @IBOutlet weak var imvSticker: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1
        var color : UIColor = .black
        if self.traitCollection.userInterfaceStyle == .dark {
            color = .white
        }
        self.contentView.layer.borderColor = color.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imvSticker.image = nil
    }
    
    public func setSticker(img: UIImage?) {
        self.imvSticker.image = img
    }
}
