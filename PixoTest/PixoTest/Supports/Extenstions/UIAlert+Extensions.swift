//
//  UIAlert+Extensions.swift
//  PixoTest
//
//  Created by Dannian Park on 2021/03/10.
//

import Foundation
import UIKit
//참고 자료 : https://stackoverflow.com/a/40688141/13049349
extension UIAlertController {
    func applyAccessibilityIdentifiers(){
        for action in actions{
            let label = action.value(forKey: "__representer")
            let view = label as? UIView
            view?.accessibilityIdentifier = action.getAcAccessibilityIdentifier()
        }
    }
}

extension UIAlertAction{
    private struct AssociatedKeys {
        static var AccessabilityIdentifier = "nsh_AccesabilityIdentifier"
    }
    func setAccessibilityIdentifie(accessabilityIdentifier: String) {
        objc_setAssociatedObject(self, &AssociatedKeys.AccessabilityIdentifier, accessabilityIdentifier, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func getAcAccessibilityIdentifier() -> String?
    {
        return objc_getAssociatedObject(self, &AssociatedKeys.AccessabilityIdentifier) as? String
    }
}
