//
//  RootView+AlbumElementViewDelegate.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

extension RootViewController: AlbumElementViewDelegate {
    func editExist() {
        self.viewModel?.permissionCheck()
    }
}
