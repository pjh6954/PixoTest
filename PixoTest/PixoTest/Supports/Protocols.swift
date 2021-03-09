//
//  Protocols.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/09.
//

import Foundation
import UIKit

/**
 EachPhotoDisplayViewController에서 콜백 받기 위한 delegate.
 */
protocol PhotoDisplayViewDelegate : class{
    /**
     - Parameter image : 수정된 이미지 저장 및 view reload를 위한 callback data // removed - 굳이 필요치 않다고 판단.
     */
    func doneEditing()
    
    /**
     이미지 수정 취소. 이 경우는 별도의 action이 없을 것으로 예상 중.
     */
    func cancelEditing()
}

/** AlbumElementViewController에서 뒤로 돌아갈 때 사용할 delegate */
protocol AlbumElementViewDelegate: class {
    /** edit 내용이 존재하여, 뒤로 돌아갈 경우 reload하기 위한 function */
    func editExist()
}
