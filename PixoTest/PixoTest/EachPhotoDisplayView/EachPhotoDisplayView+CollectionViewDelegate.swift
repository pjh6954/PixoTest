//
//  EachPhotoDisplayView+CollectionViewDelegate.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

extension EachPhotoDisplayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let img = UIImage(named: "\(indexPath.row + 1)") else { return }
        self.didSelectImage(img: img)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.stickerCell, for: indexPath) as? StickerListCVCell else {
            return StickerListCVCell()
        }
        cell.setSticker(img: UIImage(named: "\(indexPath.row + 1)"))
        /*
        //TODO: 이 부분은 추후 정리 할 때 새로 구현해보기 위해서 주석처리
        if let path : String = Bundle.main.path(forResource: "\(indexPath.row + 1)", ofType: "svg") {
            let url = NSURL.fileURL(withPath: path)
            let testimg = UIImage()
            //svg지원을 iOS 13이후부터 하기 때문에, 현재 앱에서는 @available을 이용하거나 pdf로 변환 후 이용하는걸로 통합하거나 둘 중 하나를 선택한다. 여기서는 pdf로 변환 후 이용하는걸로.
        }else{
            cell.setSticker(img: nil)
        }
        */
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.height - (constants.defaultMarginPadding * 2)
        return .init(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: constants.defaultMarginPadding, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: constants.defaultMarginPadding, height: collectionView.bounds.height)
    }
}
