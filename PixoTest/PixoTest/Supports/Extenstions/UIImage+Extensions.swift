//
//  UIImage+Extensions.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/08.
//

import Foundation
import UIKit
extension UIImage {
    //image 180도 돌리기위한 코드
    //참고 사이트 : https://stackoverflow.com/questions/40882487/how-to-rotate-image-in-swift
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
    
    func matchedSizeCalc(maximumHeight: CGFloat?, maximumWidth: CGFloat?) -> CGSize? {
        if let h = maximumHeight {
            //최대 height가 정해져있기 때문에 새로운 width를 계산한다.
            //현재 이미지의 height와 maximumHeight를 나눠서 나온 값을 w와 곱하면 새로운 w가 나온다(비율로 계산)
            //maximumWidth인 경우도 동일
            let w = (h / self.size.height) * self.size.width
            return .init(width: w, height: h)
        }
        if let w = maximumWidth {
            let h = (w / self.size.width) * self.size.height
            return .init(width: w, height: h)
        }
        return nil
    }
    
}

/*
//TODO: 자료 정리를 위해 남긴 레거시 코드 - 정리 후 삭제
extension UIImage {
    //참고 사이트 : https://stackoverflow.com/a/56096632/13049349
    //이미지 쉽게 이용하기 위해서.
    public convenience init?(_ systemItem: UIBarButtonItem.SystemItem) {

        guard let sysImage = UIImage.imageFrom(systemItem: systemItem)?.cgImage else {
            return nil
        }

        self.init(cgImage: sysImage)
    }

    private class func imageFrom(systemItem: UIBarButtonItem.SystemItem) -> UIImage? {

        let sysBarButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)

        //MARK:- Adding barButton into tool bar and rendering it.
        let toolBar = UIToolbar()
        toolBar.setItems([sysBarButtonItem], animated: false)
        toolBar.snapshotView(afterScreenUpdates: true)

        if  let buttonView = sysBarButtonItem.value(forKey: "view") as? UIView{
            for subView in buttonView.subviews {
                if subView is UIButton {
                    let button = subView as! UIButton
                    let image = button.imageView!.image!
                    return image
                }
            }
        }
        return nil
    }
}
*/
