//
//  RootViewModel.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/08.
//

import Foundation
import Photos
import UIKit

protocol RootViewModelInput: class {
    func permissionCheck()
}
protocol RootViewModelOutput: class {
    var noPermissionAlert: (() -> Void)? {get set}
    var getAlbums: (() -> Void)? {get set}
    var albumLists : [AlbumModel] {get set}
    var photoLists : [PHAsset] {get set}
    var totalLists: Int {get set}
}

protocol RootViewModelType : class {
    var inputs: RootViewModelInput {get}
    var outputs: RootViewModelOutput{get}
}
class RootViewModel : RootViewModelType, RootViewModelInput, RootViewModelOutput {
    
    //MARK: - output, variable
    var albumLists: [AlbumModel] = [] // 앨범별로 나누기 위한 변수
    var photoLists: [PHAsset] = [] // photo 전체를 보여주기 위한 변수
    var totalLists: Int = 0 // 이전 형태에서 달라져서 지금은 필요 없을 것이라고 예상 중. 확인 필요
    
    //MARK: - ViewModel Lifecycle
    init () {
        
    }
    
    deinit {
        NSLog("Check deinit in RootViewModel")
    }
    
    //MARK: - private methods
    /**
     앨범 리스트 전체 갖고오기 위한 함수.
     */
    private func getAllAlbums() {
        /*
        let options = PHFetchOptions()
        
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue) // Media Type Image만 갖고오도록 하는 부분
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]//날짜순으로 정렬
        
        let result = PHAsset.fetchAssets(with: options)
        print("ChECK Results : \(result)\n\(result.count)")
        
        */
        
        
        // 앨범리스트 담을 변수 설정
        var albumList:[AlbumModel] = [AlbumModel]()
        var photoList:[PHAsset] = [PHAsset]()
        var totalCount : Int = 0
        // 옵션 값 - default
        let fetchOptions = PHFetchOptions()
        //fetchAssetCollectionsWithType의 subtype 타입값을 설정하여 가지고 오고 싶은 앨범만 선택
        let Customalbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        let SmartAlbumPanoramas = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: fetchOptions)
        let SmartAlbumFavorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: fetchOptions)
        let SmartAlbumSelfPortraits = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: fetchOptions)
        let SmartAlbumScreenshots = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: fetchOptions)
        let SmartAlbumBursts = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumBursts, options: fetchOptions)
        let SmartAlbumRecentlyAdded = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: fetchOptions)
        let Cmeraroll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: fetchOptions)
        // 각 앨범의 사진 타이틀이름, 수 가져오기
        [SmartAlbumRecentlyAdded, Cmeraroll, SmartAlbumSelfPortraits, SmartAlbumFavorites, SmartAlbumBursts, SmartAlbumPanoramas, SmartAlbumScreenshots, Customalbums].forEach {
                $0.enumerateObjects { collection, index, stop in
                    // PHAssetCollection 의 localizedTitle 을 이용해 앨범 타이틀 가져오기
                    let albumTitle : String = collection.localizedTitle!
                    // 이미지만 가져오도록 옵션 설정.
                    let fetchOptions2 = PHFetchOptions()
                    fetchOptions2.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue) // Image만 갖고오도록 하는 부분
                    let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions2)
                    // PHFetchResult 의 count 을 이용해 앨범 사진 갯수 가져오기
                    let albumCount = assetsFetchResult.count
                    // 저장
                    let newAlbum = AlbumModel(name:albumTitle, count: albumCount, collection:collection)
                    print(newAlbum.name)
                    print(newAlbum.count)
                    //앨범 정보 추가
                    if newAlbum.count > 0 {
                        totalCount += newAlbum.count
                        albumList.append(newAlbum)
                        for i in 0 ..< newAlbum.count {
                            photoList.append(assetsFetchResult[i])
                        }
                    }
                }
            }
        
        self.albumLists = albumList
        self.photoLists = photoList
        self.totalLists = totalCount
        self.getAlbums?()
    }
    
    //MARK: - INPUTS
    func permissionCheck() {// Photo에 대한 permission check부분.
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.getAllAlbums()
                default:
                    self.noPermissionAlert?()
                    
                }
            }
        }
    }
    
    //MARK: - OUTPUTS
    var noPermissionAlert: (() -> Void)?
    var getAlbums: (() -> Void)?
    
    //MARK: - TYPES
    var inputs: RootViewModelInput {return self}
    var outputs: RootViewModelOutput{return self}
}
