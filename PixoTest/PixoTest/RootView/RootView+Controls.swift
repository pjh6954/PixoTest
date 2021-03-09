//
//  RootView+Controls.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

extension RootViewController {
    //MARK: - View Controller Display or Action Methods
    public func noPermissionAlert() {
        let alert = UIAlertController(title: "사진 권한 없음",
                                    message: "Settings -> Privacy에서 권한을 허용해주세요.",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            //TODO: ...앱 종료는 안되니 일단 정의 없음.
        }))
        alert.addAction(UIAlertAction(title: "설정으로", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func viewDisplayChanged() {//Button Action에 따라서 view가 변경되도록.
        guard let _btn = self.titleBtn else {
            return
        }
        if self.displayType == .square {
            _btn.setTitle("All Photo List", for: .normal)
            _btn.setImage(UIImage(named: "ico_arrow_down"), for: .normal)
        }
        else{
            _btn.setTitle("All Album List", for: .normal)
            _btn.setImage(UIImage(named: "ico_arrow_down")?.rotate(radians: .pi), for: .normal)
        }
        self.cvLists.reloadData()
    }
    
    //Button의 Action 정의
    @objc func titleBtnAction(_ sender : UIButton) {
        if self.displayType == .square { self.displayType = .table }
        else{ self.displayType = .square }
    }
}
