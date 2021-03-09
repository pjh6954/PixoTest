//
//  AlbumListTableCVCell.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/08.
//

import UIKit
import Photos

class AlbumListTableCVCell: UICollectionViewCell {
    //Table 처럼 보이도록 하는 Collection View Cell
    //MARK: - Outlets
    @IBOutlet weak var uivBackgroundView: UIView!
    @IBOutlet weak var imvThumbnail: UIImageView!
    @IBOutlet weak var lbAlbumTitle: UILabel!
    
    //MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //최초 로드 할 때만 imvThumbnail의 corner에 대해서 정의해주면 되기 때문에 awakeFromNib에 선언
        self.imvThumbnail.translatesAutoresizingMaskIntoConstraints = false
        self.imvThumbnail.layer.cornerRadius = 10
        self.imvThumbnail.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //재사용시 매번 호출되기 때문에, 이전 image와 title에 대해서 지워주기 위해 이 곳에 추가로 선언
        self.imvThumbnail.image = nil
        self.lbAlbumTitle.text = nil
    }
    
    //MARK: - View Data Setting Methods
    /**
     단순히 image와 title만 Setting하는 경우에 이용되는 방식
     - parameters:
        - img         : UIImage? 해당 cell의 thumbnail을 보여주기 위한 image.
        - title     : 앨범의 name을 표시하기 위한 paramter
     */
    public func setData(img: UIImage?, title: String) {
        self.imvThumbnail.image = img
        self.lbAlbumTitle.text = title
    }
    
    /**
     Collection을 이용해서 Cell의 정보를 보여주는 방식. PHAssetCollection의 result중 가장 첫 번째 데이터를 이용해서 thumbnail을 갖고온다.
     - parameters:
        - collection: PHAssetCollection. 각 앨범에 contain되어있는 PHAsset들에 대한 집합.
        - title           : 해당 Cell의 title에 이용. 각 Album의 name이 들어간다.
     */
    public func setData(collection: PHAssetCollection, title: String) {
        self.lbAlbumTitle.text = title
        
        let result = PHAsset.fetchAssets(in: collection, options: nil)
        guard let asset = result.firstObject else {
            return
        }
        let option = PHImageRequestOptions()
        option.deliveryMode = .fastFormat
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        let size : CGSize = .init(width: 80, height: 80)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: option) { (img, info) in
            self.imvThumbnail.image = img
        }
    }
}
