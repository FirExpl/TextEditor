//
//  Toolbar.swift
//  TextEditor
//
//  Created by Артём Никифоров on 3/2/20.
//  Copyright © 2020 firexpl. All rights reserved.
//

import UIKit

class ToolbarButton : UIButton {
  enum Action {
    case Tab;
    case BulletPoints;
    case Keyboard;
  }

  public let action: Action

  init(action: Action, icon: UIImage?) {
    self.action = action
    super.init(frame:.zero)

    assert(icon != nil)
    self.setImage(icon, for: .normal)
    self.tintColor = .white
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class Toolbar : UIView {
  var stackView: UIStackView!
  var actionHandler: ((ToolbarButton.Action) -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupStackView()
    self.setupButtons()
    self.setupLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setupStackView()
    self.setupButtons()
    self.setupLayout()
    self.setupLayout()
  }

  func setupStackView() {
    self.stackView = UIStackView(frame: self.bounds)
    self.stackView.axis = .horizontal
    self.stackView.alignment = .fill
    self.addSubview(self.stackView)
  }

  func setupButtons() {
    assert(self.stackView != nil)
    let tabButton = ToolbarButton(action: .Tab, icon: UIImage(named: "tab"))
    tabButton.addTarget(self,
                        action: #selector(onButton(sender:)),
                        for: .touchUpInside)
    self.stackView.addArrangedSubview(tabButton)

    let bulletPointsButton = ToolbarButton(action: .BulletPoints,
                                           icon: UIImage(named: "bullet_points"))
    bulletPointsButton.addTarget(self,
                                 action: #selector(onButton(sender:)),
                                 for: .touchUpInside)
    self.stackView.addArrangedSubview(bulletPointsButton)

    let keyboardButton = ToolbarButton(action: .Keyboard,
                                       icon: UIImage(named: "keyboard"))
    keyboardButton.addTarget(self,
                             action: #selector(onButton(sender:)),
                             for: .touchUpInside)
    self.stackView.addArrangedSubview(keyboardButton)
  }

  func setupLayout() {
    NSLayoutConstraint.activate([
      self.stackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
      self.stackView.rightAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.rightAnchor),
      self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
      self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    ])

    let firstView = self.stackView.arrangedSubviews.first!
    for view in self.stackView.arrangedSubviews {
      var constraints = [
        view.heightAnchor.constraint(equalTo: self.stackView.heightAnchor),
      ]

      if (view != firstView) {
        constraints.append(view.widthAnchor.constraint(equalTo: firstView.widthAnchor))
      }

      NSLayoutConstraint.activate(constraints)
    }
  }

  func setBackgroundColor(color: UIColor?) {
    self.backgroundColor = color
    self.stackView.backgroundColor = color
    for view in self.stackView.arrangedSubviews {
      view.backgroundColor = color
    }
  }

  @objc func onButton(sender: ToolbarButton) {
    self.actionHandler?(sender.action)
  }
}
