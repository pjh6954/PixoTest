//
//  AlbumElementViewModel.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/08.
//

import Foundation
import Photos
import UIKit

protocol AlbumElementViewModelInput: class {
    func loadDatas()
}

protocol AlbumElementViewModelOutput: class {
    var imageLists: [PHAsset] {get set}
    var imageDataAllLoaded: (() -> Void)? {get set}
}

protocol AlbumElementViewModelType: class {
    var inputs: AlbumElementViewModelInput {get}
    var outputs: AlbumElementViewModelOutput {get}
}

class AlbumElementViewModel: AlbumElementViewModelType, AlbumElementViewModelInput, AlbumElementViewModelOutput {
    
    private var collectionData : PHAssetCollection!
    
    //MARK: - ViewModel LifeCycle
    init() {
        self.collectionData = .init()
        self.imageLists = []
    }
    
    init(collection: PHAssetCollection) {
        self.collectionData = collection
        self.loadDatas()
    }
    
    deinit {
        NSLog("Check Deinit in AlbumElementViewModel")
    }
    
    //MARK: - private methods
    private func getImageFromData() {
        //?
    }
    
    //MARK: - INPUTS
    func loadDatas() {
        var newImageLists = [PHAsset]()
        let result = PHAsset.fetchAssets(in: self.collectionData, options: nil)
        NSLog("Check : \(type(of: result))")
        for index in 0 ..< result.count {
            let asset = result[index]
            newImageLists.append(asset)
        }
        self.imageLists = newImageLists
        self.imageDataAllLoaded?()
    }
    
    //MARK: - OUTPUTS
    var imageLists: [PHAsset] = []
    var imageDataAllLoaded: (() -> Void)?
    
    //MARK: - TYPES
    var inputs: AlbumElementViewModelInput {return self}
    var outputs: AlbumElementViewModelOutput {return self}
}
