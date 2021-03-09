//
//  AlbumElementView+PhotoDisplayViewDelegate.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

extension AlbumElementViewController: PhotoDisplayViewDelegate {
    func doneEditing() {
        self.isReloaded = true
        self.viewModel?.loadDatas()
    }
    
    func cancelEditing() {
        
    }
}
