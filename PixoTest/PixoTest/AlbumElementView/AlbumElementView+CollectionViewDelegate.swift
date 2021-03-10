//
//  AlbumElementView+CollectionViewDelegate.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit
import Photos

//MARK: - UICollectionView Delegates
extension AlbumElementViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.imageLists.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.squareCell, for: indexPath) as? AlbumListSquareCVCell,
            let lists = self.viewModel?.imageLists,
            lists.count > indexPath.section
            else { return AlbumListSquareCVCell() }
        cell.setData(asset: lists[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //각 셀의 size
        let size = ((collectionView.bounds.width - (constants.defaultMarginPadding * 2)) / 3)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //section header
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //section footer
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //위아래 간격
        return constants.defaultMarginPadding + 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //좌우 간격
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //NSLog("Check indexpath : \(indexPath)")
        guard let lists = self.viewModel?.imageLists, lists.count > indexPath.row else {
            return
        }
        //NSLog("Check element : \(lists[indexPath.row])")
        let asset = lists[indexPath.row]
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        //target size : 이미지가 return 될 때 목표하는 사이즈. Screen size와 맞게 해주자.
        let size : CGSize = UIScreen.main.bounds.size//.init(width: , height: 80)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: option) { (img, info) in
            //self.imvThumbnailSquare.image = img
            //NSLog("image Check : \(img)")
            //NSLog("Breaker")
            
            guard let img = img else {return}
            
            let vc = EachPhotoDisplayViewController(nibName: "EachPhotoDisplayView", bundle: Bundle(for: EachPhotoDisplayViewController.self))
            vc.delegate = self
            vc.image = img
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
}
