//
//  AlbumElementViewController.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/08.
//

import Foundation
import UIKit
import Photos

class AlbumElementViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var cvLists: UICollectionView!
    
    
    //MARK: - Variables
    public var delegate : AlbumElementViewDelegate? = nil
    public var albumData : AlbumModel?
    public var viewModel : AlbumElementViewModel? = nil
    public var squareCell : String = String(describing: AlbumListSquareCVCell.self)
    public var isReloaded: Bool = false // EachPhotoDisplay에서 새로 생성한 경우 true가 되고, 이 때는 이전 뷰로 돌아갈 때 이전뷰에 대해서 reload가 필요하다.
    
    private var _albumData : AlbumModel = .init()
    
    
    //MARK: - View Controller Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.navigationBarSetting()
        guard let _data = self.albumData else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self._albumData = _data
        self.viewModelBinding()
    }
    
    deinit {
        NSLog("deinit in AlbumElementViewController")
    }
    
    //MARK: - View Controller Setting methods
    private func commonInit() {
        self.cvLists.accessibilityIdentifier = "Albums.CV"//UITest를 위한 ID
        self.cvLists.delegate = self
        self.cvLists.dataSource = self
        
        let nibSquare = UINib(nibName: self.squareCell, bundle: nil)
        self.cvLists.register(nibSquare, forCellWithReuseIdentifier: self.squareCell)
    }
    
    private func navigationBarSetting() {
        let naviTitleView = UIView(frame: .zero)
        naviTitleView.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        naviTitleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            .init(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: naviTitleView, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: naviTitleView, attribute: .top, multiplier: 1, constant: 0),
            .init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: naviTitleView, attribute: .centerX, multiplier: 1, constant: 0),
            .init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: naviTitleView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        if let _data = self.albumData{
            titleLabel.text = _data.name
        }
        else{
            titleLabel.text = "앨범 정보가 없습니다."
        }
        
        //새로운 back button 생성
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.btnBackAction(_:)))
        backButton.accessibilityIdentifier = "Albums.Back"
        self.navigationItem.leftBarButtonItem = backButton
        
        //MARK: color setting
        var color : UIColor = .black
        if self.traitCollection.userInterfaceStyle == .dark {
            color = .white
        }
        titleLabel.textColor = color
        
        self.navigationItem.titleView = naviTitleView
    }
    
    //MARK: - View Controller ViewModel Setting methods
    private func viewModelBinding() {
        //
        if self.viewModel == nil {
            self.viewModel = .init(collection: self._albumData.collection)
        }
        guard let vm = self.viewModel else {
            return
        }
        vm.imageDataAllLoaded = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.cvLists.reloadData()
        }
        //self.testCodeForList()
    }
    
    private func testCodeForList() {
        let collection = self._albumData.collection
        let result = PHAsset.fetchAssets(in: collection, options: nil)
        NSLog("Check result : \(result)")
    }
    
    @objc func btnBackAction(_ sender : UIBarButtonItem) {
        if self.isReloaded {
            //
            self.delegate?.editExist()
        }
        self.navigationController?.popViewController(animated: true)
    }
}
