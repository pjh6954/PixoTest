//
//  EachPhotoDisplayView+Gestures.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

extension EachPhotoDisplayViewController : UIGestureRecognizerDelegate{
    /**
     UIPanGestureRecognizer - Object 이동 제어
     */
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            if view is UIImageView {
                //Tap only on visible parts on the image
                if recognizer.state == .began {
                    for imageView in self.subImageViews(view: self.imvCanvas) {
                        let location = recognizer.location(in: imageView)
                        let alpha = imageView.alphaAtPoint(location) // 이 부분이 필요한 이유는 이미지의 투명한 부분을 선택 했을 때는 움직이지 않게 하기 위해서 필요한 것.
                        if alpha > 0 {
                            self.imageViewToPan = imageView
                            break
                        }
                    }
                }
                if let pan = self.imageViewToPan {
                    self.moveView(view: pan, recognizer: recognizer)
                }
            } else {
                //uiimageview외에 move가 필요한 경우.
                self.moveView(view: view, recognizer: recognizer)
            }
        }
    }
    
    /**
     실질적으로 view를 이동하는데 쓰이는 method
     */
    func moveView(view: UIView, recognizer: UIPanGestureRecognizer)  {
        view.superview?.bringSubviewToFront(view)
        let pointToSuperView = recognizer.location(in: self.view)
        view.center = CGPoint(x: view.center.x + recognizer.translation(in: self.imvCanvas).x,
                              y: view.center.y + recognizer.translation(in: self.imvCanvas).y)
        
        recognizer.setTranslation(CGPoint.zero, in: self.imvCanvas)
        self.lastPanPoint = pointToSuperView
        
        if recognizer.state == .ended {
            self.imageViewToPan = nil
            self.lastPanPoint = nil
            if !self.imvCanvas.bounds.contains(view.center) { //Snap the view back to canvasImageView
                UIView.animate(withDuration: 0.3, animations: {
                    view.center = self.imvCanvas.center
                })
                
            }
        }
    }
    
    /**
     특정 view의 하위에 포함된 imageView를 갖고오기 위한 method. 여러개가 있을 수 있다.
     */
    func subImageViews(view: UIView) -> [UIImageView] {
        var imageviews: [UIImageView] = []
        for imageView in view.subviews {
            guard imageView is UIImageView else { continue }
            imageviews.append(imageView as! UIImageView)
            /*
            if imageView is UIImageView {
                imageviews.append(imageView as! UIImageView)
            }
            */
        }
        return imageviews
    }
}
