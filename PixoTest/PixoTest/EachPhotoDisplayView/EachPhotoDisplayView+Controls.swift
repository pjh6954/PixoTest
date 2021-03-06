//
//  EachPhotoDisplayView+Controls.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

//MARK: Controls (Button Action and Controller Move)
extension EachPhotoDisplayViewController {
    /**
     btnClose의 action 정의
     */
    @objc func btnCloseAction(_ sender: UIButton) {
        self.goBackAction {
            self.delegate?.cancelEditing()
        }
    }
    
    /**
     btnOverlaySave의 action 정의
     */
    @objc func btnOverlayAction(_ sender: UIButton) {
        //save
        UIImageWriteToSavedPhotosAlbum(self.canvas.toImage(),self, #selector(self.image(_:withPotentialError:contextInfo:)), nil)
        //UIImageWriteToSavedPhotosAlbum(self.canvas.toImage(CGRect(x: self.canvas.bounds.minX, y: self.canvas.bounds.minY, width: self.canvas.bounds.size.width / 2, height: self.canvas.bounds.size.height / 2)),self, #selector(self.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    /**
     save photo album의 completionSelector 정의
     */
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "이미지 저장 완료", message: "Photos Library에 저장되었습니다.", preferredStyle: UIAlertController.Style.alert)
        alert.view.accessibilityIdentifier = "Each.Alert"
        let action = UIAlertAction(title: "나가기", style: UIAlertAction.Style.default, handler: { (act) in
            self.goBackAction {
                self.delegate?.doneEditing()
            }
        })
        action.accessibilityIdentifier = "Each.Check" // for UITest
        action.accessibilityLabel = "Each.Check.Label"
        alert.addAction(action)
        self.present(alert, animated: true, completion: {
            //alert.applyAccessibilityIdentifiers()
        })
    }
    
    /**
     현재 present View의 dismiss Action 정의. animate true를 default로.
     */
    func goBackAction(_ completion: (() -> Void)? = nil) {
        self.dismiss(animated: true, completion: completion)
    }
}
