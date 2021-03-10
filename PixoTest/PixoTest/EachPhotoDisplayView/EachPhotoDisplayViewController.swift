//
//  EachPhotoDisplayViewController.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit



class EachPhotoDisplayViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnOverlaySave: UIButton!
    
    //imvCanvas에 Sticker를 붙이고, save시 imvDefault의 image와 imvCanvas의 sticker를 이용해서 새 이미지를 만들어서 저장.
    //Default image and stickerview container
    @IBOutlet weak var canvas: UIView!
    
    //Default Image
    @IBOutlet weak var imvDefault: UIImageView!
    //@IBOutlet weak var imvDefaultHeightConstraint: NSLayoutConstraint! // height 650으로 되어있는 것. 동적 변환 가능한지 테스트용.
    
    //For Sticker
    @IBOutlet weak var imvCanvas: UIImageView!
    
    
    //Sticker svg이미지들을 보여주는 collectionView
    @IBOutlet weak var cvStickerList: UICollectionView!
    
    //MARK: - Constnats
    public let stickerCell : String = String(describing: StickerListCVCell.self)
    
    //MARK: - Variables
    public var delegate : PhotoDisplayViewDelegate? = nil
    
    public var image : UIImage? = nil
    
    public var lastPanPoint: CGPoint?
    public var imageViewToPan: UIImageView?
    
    
    //MARK: - View Controller Lifecycle methods
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    deinit {
        NSLog("Deinit in Each Photo Display View Controller")
    }
    
    
    //MARK: - View Controller Setting methods
    private func commonInit() {
        guard let img = self.image else {
            //image가 없으므로 정상적인 접근이 아니게 된다.
            self.goBackAction(nil)
            return
        }
        self.settingImageView(image: img)
        
        //MARK: Close Button Setting
        self.btnClose.addTarget(self, action: #selector(self.btnCloseAction(_:)), for: .touchUpInside)
        self.btnClose.accessibilityIdentifier = "Each.Back" // for UITest
        
        
        //MARK: Overlay Button Setting
        self.btnOverlaySave.setTitle("Overlay", for: .normal)
        self.btnOverlaySave.addTarget(self, action: #selector(self.btnOverlayAction(_:)), for: .touchUpInside)
        self.btnOverlaySave.accessibilityIdentifier = "Each.Save" // for UITest
        self.btnOverlaySave.layer.cornerRadius = self.btnOverlaySave.bounds.height / 2
        //self.btnOverlaySave.layer.borderWidth = 1
        self.overlayBtnDisplaySetting()
        
        //MARK: CollectionView Setting
        let cvCell = UINib(nibName: self.stickerCell, bundle: nil)
        self.cvStickerList.register(cvCell, forCellWithReuseIdentifier: self.stickerCell)
        self.cvStickerList.accessibilityIdentifier = "Each.CV" // for UITest
        self.cvStickerList.delegate = self
        self.cvStickerList.dataSource = self
        
        //MARK: Color Setting
        var color : UIColor = .black
        if self.traitCollection.userInterfaceStyle == .dark {
            color = .white
        }
        self.btnClose.tintColor = color
        self.btnOverlaySave.tintColor = (color == .white ? .black : .white)
        self.btnOverlaySave.backgroundColor = color
    }
    
    //MARK: default Image View Setting
    private func settingImageView(image: UIImage) {
        self.imvDefault.image = image
        //TODO: 중앙 정렬 때문에 테스트를 위한 코드. 차후 개선
        //let size = image.matchedSizeCalc(maximumHeight: nil, maximumWidth: UIScreen.main.bounds.width) // width만 넣는 이유는 height는 특정하기 어려운 가변이지만, width는 가변이긴 하되 확실히 정해져있는 사이즈가 있기 때문(screen size의 width만큼.)
        //self.imvDefaultHeightConstraint.constant = (size?.height)!
    }
    
    //MARK: Overlay Button Display Setting
    func overlayBtnDisplaySetting() {
        self.btnOverlaySave.isHidden = !self.imvCanvas.subviews.contains { (sub) -> Bool in
            return sub is UIImageView
        }
    }
}
