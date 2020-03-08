//
//  ViewController.swift
//  TextEditor
//
//  Created by Артём Никифоров on 3/2/20.
//  Copyright © 2020 firexpl. All rights reserved.
//

import UIKit

class TextEditController: UIViewController, UITextViewDelegate {
  @IBOutlet var textView: UITextView!
  @IBOutlet var toolbar: Toolbar!
  @IBOutlet var toolbarBottom: NSLayoutConstraint!
  var keyboardController: KeyboardController!
  var textViewManager: TextViewManager!
  var animator : UIViewPropertyAnimator? = nil

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupToolbar()
    self.setupKeyboardController()
    self.setupTextViewManager()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.keyboardController.startListenToKeyboardEvents()
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.keyboardController.stopListenToKeyboardEvents()
    super.viewWillDisappear(animated)
  }

  // MARK: - setup

  func setupToolbar() {
    self.toolbar.setBackgroundColor(color: self.toolbar.backgroundColor)
    self.toolbar.actionHandler = { (action: ToolbarButton.Action) in
      switch action {
      case .Tab:
        self.onTabAction()
      case .BulletPoints:
        self.onBulletPointsAction()
      case .Keyboard:
        self.onKeyboardButton()
      }
    }
  }

  func setupKeyboardController() {
    self.keyboardController = KeyboardController(handler: { [weak self](frame, duration, curve) in
      self?.animateToolbar(toFrame: frame,
                           duration: duration,
                           curve: UIView.AnimationCurve.curve(withOption:curve))
    })
  }

  func setupTextViewManager() {
    self.textViewManager = TextViewManager(withTextView: self.textView)
  }

  // MARK: - actions

  func onTabAction() {
    self.textViewManager.insertTabCharacter()
  }

  func onBulletPointsAction() {
    self.textViewManager.insertBulletPoint()
  }

  func onKeyboardButton() {
    if self.textView.isFirstResponder {
      self.textView.resignFirstResponder()
    } else {
      self.textView.becomeFirstResponder()
    }
  }

  // MARK: animate toolbar
  func animateToolbar(toFrame frame: CGRect, duration: TimeInterval, curve: UIView.AnimationCurve) {
    print("frame: \(frame); duration: \(duration)")
    let height = self.view.frame.size.height
    let diff = frame.minY - height
    let constant = diff != 0 ? self.view.safeAreaInsets.bottom + diff : diff
    self.toolbarBottom.constant = constant
    if duration > 0 {
      self.animator?.stopAnimation(true)
      self.animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
        self.view.layoutIfNeeded()
      }
      self.animator?.startAnimation()
    } else {
      self.view.layoutIfNeeded()
    }
  }
}

extension UIView.AnimationCurve {
  static func curve(withOption option: UIView.AnimationOptions) -> UIView.AnimationCurve {
    switch option {
    case .curveEaseIn:
      return .easeIn
    case .curveEaseOut:
      return .easeOut
    case .curveEaseInOut:
      return .easeInOut
    default:
      return .linear
    }
  }
}
