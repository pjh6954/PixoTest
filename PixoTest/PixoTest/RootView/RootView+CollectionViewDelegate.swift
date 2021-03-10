//
//  RootViewController+CollectionViewDelegate.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit
import Photos

//MARK: - UICollectionView Delegates
extension RootViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //Section이 이용되는 방식은 Square일 경우에는 1개만 필요(모든 Photo가 보여지기 때문에 Section으로 나누지 아니함.
    //Table인 경우에는 각 Collection 별로 따로 보여줘야 하기 때문에 Collection을 포함하는 albumLists갯수만큼 반환한다.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.displayType == .square {
            collectionView.accessibilityIdentifier = "RootView.CV.Square" // for uitest
            return 1
        }
        else{
            collectionView.accessibilityIdentifier = "RootView.CV.Table" // for uitest
            return self.viewModel?.albumLists.count ?? 0
        }
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.displayType == .square {
            /*
            let resultCount = self.viewModel?.albumLists.compactMap({ (model) -> Int? in
                if model.count > 0 { return model.count }
                else{ return nil }
            }).reduce(0, +) ?? 0
            NSLog("Check result Count : Total : \(resultCount)")
             NSLog("Data count : \(self.viewModel?.totalLists)")
            return resultCount
            */
            return self.viewModel?.photoLists.count ?? 0
            //guard let lists = self.viewModel?.albumLists else {return 0}
            //return lists[section].count
        }
        else{ return 1 }
    }
    /*
    fileprivate func selectCollectionData(indexPath: IndexPath, lists: [AlbumModel]) -> (AlbumModel?, Int)? {
        
        var albumModelData : AlbumModel? = nil
        var listIndex : Int = 0
        var index : Int = 0 // element의 index 계산
        var counter : Int = 0
        repeat {
            guard lists.count > listIndex else {
                break
            }
            let data = lists[listIndex]
            counter += data.count
            NSLog("Checker album : \(counter) ++ \(data.count) || \(index) :: \(indexPath)")
            if counter > indexPath.row, data.count != 0 {
                //특정 인덱스의 photo를 보여주기 위한 계산 값 : indexPath.row - (counter - data.count)
                //이 계산식이 나오는 이유 : lists들을 0번 인덱스 부터 n 까지 각 element의 collection들을 차례로 뿌려줬기 때문.
                index = indexPath.row - (counter - data.count)
                albumModelData = data
                break
            }else{
                listIndex += 1
            }
        } while (albumModelData == nil)
        NSLog("Return data : \(index)")
        return (albumModelData, index)
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.displayType == .square {
            /*
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.squareCell, for: indexPath) as? AlbumListSquareCVCell,
                let lists = self.viewModel?.albumLists,
                lists.count > indexPath.section
                else { return AlbumListSquareCVCell() }
            let result = PHAsset.fetchAssets(in: lists[indexPath.section].collection, options: nil)
            guard result.count > indexPath.row else {
                return cell
            }
            cell.setData(asset: result[indexPath.row])
            return cell
            */
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.squareCell, for: indexPath) as? AlbumListSquareCVCell,
                let lists = self.viewModel?.photoLists
                else { return AlbumListSquareCVCell() }
            
            if lists.count > indexPath.row {
                cell.setData(asset: lists[indexPath.row])
            }
            return cell
            
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.tableCell, for: indexPath) as? AlbumListTableCVCell else {
                return AlbumListTableCVCell()
            }
            guard let _list = self.viewModel?.albumLists, _list.count > indexPath.section else { return cell }
            NSLog("INDEX : \(indexPath.section) :: \(_list[indexPath.section].name)")
            let data = _list[indexPath.section]
            //cell.setData(img: data.thumbnail, title: data.name)
            cell.setData(collection: data.collection, title: data.name)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //각 cell의 size
        if self.displayType == .square {
            let size = ((collectionView.bounds.width - (constants.defaultMarginPadding * 2)) / 3)
            return CGSize(width: size, height: size)
        }
        else { return CGSize(width: collectionView.bounds.width, height: constants.tableCellHeight) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //section header height
        if self.displayType == .square { return CGSize(width: collectionView.bounds.width, height: 20) }
        else { return .zero }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //section footer height
        if self.displayType == .square { return .init(width: collectionView.bounds.width, height: 20) }
        else { return .zero }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //위아래 간격(displayType == square)
        if self.displayType == .square { return constants.defaultMarginPadding + 10}
        else { return .zero }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //좌우 간격(displayType == square)
        if self.displayType == .square {
            return constants.defaultMarginPadding
        }
        else { return .zero }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("Index : \(indexPath)")
        //수정 후 돌아올 때는 Delegate를 통해서 전체 view를 다시 load한 번 해줘야 한다.
        if self.displayType == .square {
            //각 image별로 수정하는 view로 이동시킨다.
            guard let lists = self.viewModel?.photoLists, lists.count > indexPath.row else {
                return
            }
            let asset = lists[indexPath.row]
            let option = PHImageRequestOptions()
            option.deliveryMode = .highQualityFormat
            option.isSynchronous = false
            option.isNetworkAccessAllowed = true
            //target size : 이미지가 return 될 때 목표하는 사이즈. Screen size와 맞게 해주자.
            let size : CGSize = UIScreen.main.bounds.size//.init(width: , height: 80)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: option) { (img, info) in
                
                guard let img = img else {return}
                
                let vc = EachPhotoDisplayViewController(nibName: "EachPhotoDisplayView", bundle: Bundle(for: EachPhotoDisplayViewController.self))
                vc.delegate = self
                vc.image = img
                vc.modalPresentationStyle = .currentContext
                self.present(vc, animated: true, completion: nil)
            }
        }
        else {
            //해당하는 AlbumList를 띄워주는 View로 이동해야 한다. 해당 View에서는 위의 square일 때와 동일하게 동작해야 한다.
            guard let lists = self.viewModel?.albumLists,
                  lists.count > indexPath.section
                else { return }
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlbumElementViewController") as? AlbumElementViewController
                else { return }
            vc.albumData = lists[indexPath.section]
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
