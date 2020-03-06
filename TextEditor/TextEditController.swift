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
  var documentModel: DocumentModel!

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setupToolbar()
    self.setupKeyboardController()
    self.setupDocumentModel()
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
    self.keyboardController = KeyboardController(handler: { (frame, duration, curve) in
      let height = self.view.frame.size.height
      let diff = frame.minY - height
      let constant = diff != 0 ? self.view.safeAreaInsets.bottom + diff : diff
      self.toolbarBottom.constant = constant
      self.view.layer.removeAllAnimations()
      UIView.animate(withDuration: duration,
                     delay: 0.0,
                     options: curve.union(UIView.AnimationOptions.beginFromCurrentState),
                     animations: {
                      self.view.layoutIfNeeded()
                     },
                     completion: nil)

    })
  }

  func setupDocumentModel() {
    self.documentModel = DocumentModel()
    self.textView.delegate = self.documentModel
  }

  // MARK: - actions

  func onTabAction() {
    self.documentModel.insertTabCharacter(toTextView: self.textView)
  }

  func onBulletPointsAction() {

  }

  func onKeyboardButton() {
    if self.textView.isFirstResponder {
      self.textView.resignFirstResponder()
    } else {
      self.textView.becomeFirstResponder()
    }
  }

}
