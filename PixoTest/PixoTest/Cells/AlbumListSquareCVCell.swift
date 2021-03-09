//
//  AlbumListSquareCVCell.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/08.
//

import UIKit
import Photos

class AlbumListSquareCVCell: UICollectionViewCell {
    //정사각형을 보여주는 Cell
    //MARK: - Outlets
    @IBOutlet weak var imvThumbnailSquare: UIImageView!
    
    //MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //최초 로드 할 때만 imvThumbnail의 corner에 대해서 정의해주면 되기 때문에 awakeFromNib에 선언
        self.imvThumbnailSquare.translatesAutoresizingMaskIntoConstraints = false
        self.imvThumbnailSquare.layer.cornerRadius = 10
        self.imvThumbnailSquare.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //재사용시 매번 호출되기 때문에, 이전 image에 대해서 지워주기 위해 이 곳에 추가로 선언
        self.imvThumbnailSquare.image = nil
    }
    
    //MARK: - Data Setting Methods
    /**
     단순히 이미지를 setting 하는 경우의 method
     - parameter img : UIImage. Optional은 애초에 사용되지 않을 것이라고 판단했기 때문에 non-Optional
     */
    public func setData(img: UIImage) {
        //
        self.imvThumbnailSquare.image = img
    }
    
    /**
     PHAsset을 이용해서 cell을 Setting하는 method
     - parameter asset : PHAsset. thumbnail을 보여줄 것이기 때문에 deliveryMode가 .fastFormat이다. size : CGSize(width:80, height: 80)
     */
    public func setData(asset: PHAsset) {
        let option = PHImageRequestOptions()
        option.deliveryMode = .fastFormat
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        let size : CGSize = .init(width: 80, height: 80)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: option) { (img, info) in
            self.imvThumbnailSquare.image = img
        }
    }
}
