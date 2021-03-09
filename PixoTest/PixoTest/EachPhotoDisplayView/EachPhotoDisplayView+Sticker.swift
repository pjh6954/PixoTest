//
//  EachPhotoDisplayView+Sticker.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

extension EachPhotoDisplayViewController {
    /**
     Sticker들을 삭제 할 경우 사용할 method. 정의는 했지만, 일단 필요 없을 것 같아서 imvCanvas만 userInteractionEnable = true로 변경해둠.
     */
    func removeStickers() {
        self.imvCanvas.isUserInteractionEnabled = true
    }
    
    /**
     특정 Sticker CollectionViewCell을 선택한 경우 호출되는 method.
     해당 sticker의 image를 UIImageView에 넣고, 해당 UIImageView에 gesture를 넣고 imvCanvas에 추가한다.
     - Notice : imvDefault에 추가하는것이 아님.
     */
    func didSelectImage(img: UIImage) {
        self.removeStickers()
        
        let imageView = UIImageView(image: img)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 150, height: 150)
        imageView.center = self.imvCanvas.center
        
        self.imvCanvas.addSubview(imageView)
        //Gestures
        self.addGestures(view: imageView)
        self.overlayBtnDisplaySetting()
        
    }
    
    //이동 제스쳐 추가
    func addGestures(view: UIView) {
        //Gestures
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
}
