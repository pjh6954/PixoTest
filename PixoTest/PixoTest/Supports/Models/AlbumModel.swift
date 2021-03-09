//
//  AlbumModel.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/08.
//

import Foundation
import UIKit
import Photos
class AlbumModel {
    let name: String
    let count: Int
    let collection: PHAssetCollection
    var asset: PHAsset? = nil
    var thumbnail : UIImage? = nil
    init() {
        self.name = ""
        self.count = 0
        self.collection = .init()
    }
    //MARK: - For Album List
    /**
     앨범 종류에 맞춰 이용하기 위한 데이터 모델 init
     */
    init(name: String, count: Int, collection: PHAssetCollection) {
        self.name = name
        self.count = count
        self.collection = collection
        let result : PHFetchResult = PHAsset.fetchAssets(in: collection, options: nil)
        if let asset = result.firstObject {
            self.asset = asset
            let option = PHImageRequestOptions()
            option.deliveryMode = .fastFormat
            option.isSynchronous = false
            option.isNetworkAccessAllowed = true
            let size : CGSize = .init(width: 80, height: 80)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: option) { (img, info) in
                self.thumbnail = img
            }
        }
    }
}
//TODO: albumModel만 이용하는 형태에서 photoModel 추가되는 식으로 수정

