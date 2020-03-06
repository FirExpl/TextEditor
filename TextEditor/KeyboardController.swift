//
//  ToolbarController.swift
//  TextEditor
//
//  Created by Артём Никифоров on 3/2/20.
//  Copyright © 2020 firexpl. All rights reserved.
//

import UIKit

class KeyboardController {
  typealias KeyboardFrameChangedHandler = (CGRect, TimeInterval, UIView.AnimationOptions) -> Void
  let handler: KeyboardFrameChangedHandler
  init(handler: @escaping KeyboardFrameChangedHandler) {
    self.handler = handler
  }

  deinit {
    self.stopListenToKeyboardEvents()
  }

  // MARK: - keyboard events
  public func startListenToKeyboardEvents() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(onKeyboardFrameChanges(notification:)),
                                           name:UIResponder.keyboardWillChangeFrameNotification,
                                           object: nil)
  }

  public func stopListenToKeyboardEvents() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillChangeFrameNotification,
                                              object: nil)
  }

  @objc func onKeyboardFrameChanges(notification: Notification) {
    let userInfo = notification.userInfo
    let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
    let curveValue = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue
    let curveAnimationOptions = UIView.AnimationOptions(rawValue: curveValue << 16)
    self.handler(keyboardFrame, duration, curveAnimationOptions)
  }
}
