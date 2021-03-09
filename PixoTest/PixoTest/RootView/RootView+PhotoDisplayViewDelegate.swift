//
//  RootViewController+PhotoDisplayViewDelegate.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

extension RootViewController: PhotoDisplayViewDelegate {
    func doneEditing() {
        self.viewModel?.permissionCheck()
    }
    
    func cancelEditing() {
        
    }
}
