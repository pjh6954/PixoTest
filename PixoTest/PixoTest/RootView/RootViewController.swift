//
//  RootViewController.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/08.
//

import UIKit
import Photos
class RootViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var cvLists: UICollectionView!
    
    //MARK: - Variables
    public var titleBtn : UIButton? = nil
    public var viewModel : RootViewModel? = nil
    public var displayType: listDisplayType = .square{ // default
        didSet { self.viewDisplayChanged() }
    }
    
    //MARK: - Constants
    public let squareCell : String = String(describing: AlbumListSquareCVCell.self)
    public let tableCell : String = String(describing: AlbumListTableCVCell.self)
    
    //MARK: - View Controller Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.navigationBarSetting()
        self.viewModelBinding()
        self.viewModel?.permissionCheck()
    }
    
    deinit {
        NSLog("deinit in RootViewController")
    }
    
    //MARK: - View Controller Setting methods
    private func commonInit() {
        //한 번만 호출할 부분을 정의
        self.cvLists.delegate = self
        self.cvLists.dataSource = self
        
        let nibSquare = UINib(nibName: self.squareCell, bundle: nil)
        self.cvLists.register(nibSquare, forCellWithReuseIdentifier: self.squareCell)
        
        let nibTable = UINib(nibName: self.tableCell, bundle: nil)
        self.cvLists.register(nibTable, forCellWithReuseIdentifier: self.tableCell)
    }
    
    private func navigationBarSetting() {
        let btn = UIButton(frame: .zero)
        btn.accessibilityIdentifier = "RootView.NaviTitleBtn" // UITest를 위한 ID
        btn.addTarget(self, action: #selector(self.titleBtnAction(_:)), for: .touchUpInside)
        btn.semanticContentAttribute = .forceRightToLeft
        
        //StackView로 추가하는 이유는, Element에 따라서 Stackview의 width가 변경되는 특성을 이용하여 최초 navigationItem.titleView = btn시 내부 contents size가 달라져도 반영되지 않는 문제를 쉽게 해결하기 위해서 이용.
        let stackView = UIStackView(frame: .zero)
        stackView.addArrangedSubview(btn)
        self.navigationItem.titleView = stackView
        
        //MARK: View Color Setting
        var color : UIColor = .black
        if self.traitCollection.userInterfaceStyle == .dark {
            color = .white
        }
        btn.setTitleColor(color, for: .normal)
        self.navigationController?.navigationBar.tintColor = color
        
        self.titleBtn = btn
        self.viewDisplayChanged()
    }
    
    //MARK: - View Controller ViewModel Setting methods
    private func viewModelBinding() { // Viewmodel의 output정의
        if self.viewModel == nil {
            self.viewModel = .init()
        }
        
        guard let vm = self.viewModel else {
            return
        }
        vm.noPermissionAlert = { [weak self] in
            //Permission이 denied등 Allow상태가 아닌 경우 호출되어 유저가 직접 setting하도록 유도.
            guard let strongSelf = self else {
                return
            }
            strongSelf.noPermissionAlert()
        }
        vm.getAlbums = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            //Collection View reload data - 데이터를 불러왔을 경우에 이 method가 호출되므로 여기서 reload를 해준다.
            strongSelf.cvLists.reloadData()
        }
    }
}



