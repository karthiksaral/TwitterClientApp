//
//  keyboardHandler.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 25/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardAvoidable: class {
    func addKeyboardObservers(customBlock: ((CGFloat) -> Void)?)
    func removeKeyboardObservers()
    var layoutConstraintsToAdjust: [NSLayoutConstraint] { get }
}

var KeyboardShowObserverObjectKey: UInt8 = 1
var KeyboardHideObserverObjectKey: UInt8 = 2

extension KeyboardAvoidable where Self: UIViewController {
    
    var keyboardShowObserverObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self,
                                            &KeyboardShowObserverObjectKey) as? NSObjectProtocol
        }
        set {
            
            objc_setAssociatedObject(self,
                                     &KeyboardShowObserverObjectKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var keyboardHideObserverObject: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self,
                                            &KeyboardHideObserverObjectKey) as? NSObjectProtocol
        }
        set {
            
            objc_setAssociatedObject(self,
                                     &KeyboardHideObserverObjectKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addKeyboardObservers(customBlock: ((CGFloat) -> Void)? = nil) {
        keyboardShowObserverObject = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow,
                                                                            object: nil,
                                                                            queue: nil) { [weak self] notification in
                                                                                
                                                                                guard let height = self?.getKeyboardHeightFrom(notification: notification) else { return }
                                                                                
                                                                                if let customBlock = customBlock {
                                                                                    customBlock(height)
                                                                                    return
                                                                                }
                                                                                
                                                                                self?.layoutConstraintsToAdjust.forEach {
                                                                                    $0.constant = height
                                                                                }
                                                                                
                                                                                UIView.animate(withDuration: 0.2){
                                                                                    self?.view.layoutIfNeeded()
                                                                                }
        }
        
        keyboardHideObserverObject = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide,
                                                                            object: nil,
                                                                            queue: nil) { [weak self] notification in
                                                                                
                                                                                if let customBlock = customBlock {
                                                                                    customBlock(0)
                                                                                    return
                                                                                }
                                                                                
                                                                                self?.layoutConstraintsToAdjust.forEach {
                                                                                    $0.constant = 0
                                                                                }
                                                                                
                                                                                UIView.animate(withDuration: 0.2){
                                                                                    self?.view.layoutIfNeeded()
                                                                                }
        }
    }
    
    private func getKeyboardHeightFrom(notification: Notification) -> CGFloat {
        guard let info = notification.userInfo else { return .leastNormalMagnitude }
        guard let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return .leastNormalMagnitude }
        let keyboardSize = value.cgRectValue.size
        return keyboardSize.height
    }
    
    func removeKeyboardObservers() {
        if let keyboardShowObserverObject = keyboardShowObserverObject {
            NotificationCenter.default.removeObserver(keyboardShowObserverObject)
        }
        if let keyboardHideObserverObject = keyboardHideObserverObject {
            NotificationCenter.default.removeObserver(keyboardHideObserverObject)
        }
        keyboardShowObserverObject = nil
        keyboardHideObserverObject = nil
    }
}
