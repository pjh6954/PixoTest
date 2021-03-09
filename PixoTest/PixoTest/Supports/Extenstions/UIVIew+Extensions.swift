//
//  UIVIew+Extensions.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

extension UIView {
    /**
     UIView를 UIImage로 변환한다.
     참고자료 : https://stackoverflow.com/a/38894373/13049349
     */
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
}
