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
    //해상도 변경을 위해서는 newBounds 값을 넣어줌. 그 외는 그대로
    func toImage(_ newBounds: CGRect? = nil) -> UIImage {
        var toBounds : CGRect = self.bounds
        var toSize : CGSize = self.bounds.size
        if let _bounds = newBounds {
            toBounds = _bounds
            toSize = _bounds.size
        }
        UIGraphicsBeginImageContextWithOptions(toSize, self.isOpaque, 0.0)
        self.drawHierarchy(in: toBounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
}
