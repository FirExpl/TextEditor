//
//  DocumentModel.swift
//  TextEditor
//
//  Created by Артём Никифоров on 3/3/20.
//  Copyright © 2020 firexpl. All rights reserved.
//

import UIKit

class TextViewManager : NSObject, UITextViewDelegate {
  var tabCharacter : String = "\t"
  var bulletPointCharacter: String = "•"
  let textView : UITextView

  public init(withTextView textView: UITextView) {
    self.textView = textView

    super.init()

    self.textView.delegate = self
  }

  func insertTabCharacter() {
    if let selectedRange = textView.selectedTextRange {
      textView.replace(selectedRange, withText: tabCharacter)
    }
  }

  func insertBulletPoint() {
    if let selectedRange = textView.selectedTextRange {
      let location = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
      let lineStart = textView.text.lineStartIndex(beforeLocation: location)
      let indentation = textView.text.indentation(from: lineStart,
                                                  withPrefix: bulletPointCharacter) ?? ""
      if let bulletRange = textView.text.range(of: bulletPointCharacter,
                                               range:lineStart..<textView.text.endIndex) {
        // indentation with bullet point => remove bullet point
        let indentationRange = textView.text.range(of: indentation,
                                                   range: lineStart..<textView.text.endIndex)!
        textView.text.replaceSubrange(indentationRange,
                                      with: textView.text[indentationRange.lowerBound..<bulletRange.lowerBound])
      } else if indentation.count > 0 {
        // indentation without bullet point => add bullet point after indentation
        let indentationRange = textView.text.range(of: indentation,
                                                   range: lineStart..<textView.text.endIndex)!
        textView.text.replaceSubrange(indentationRange,
                                      with: indentation + bulletPointCharacter)
      } else {
        // no identation no bullet point => add bullet point to beginning of the line
        textView.text.replaceSubrange(lineStart..<lineStart, with: bulletPointCharacter)
      }
    }
  }

  // MARK: - UITextViewDelegate
  func textView(_ textView: UITextView,
                shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    if text.isNewLine,
       let currentLineStart = textView.text?.lineStartIndex(beforeLocation: range.location),
      let indentation = textView.text.indentation(from: currentLineStart,
                                                  withPrefix: bulletPointCharacter) {
      let nsFullText = textView.text as NSString
      textView.text = nsFullText.replacingCharacters(in: range,
                                                     with: "\n" + indentation)
      return false
    }
    return true
  }
}

internal extension String {
  var isNewLine : Bool {
    return (self as NSString).rangeOfCharacter(from: CharacterSet.newlines).location != NSNotFound
  }

  func index(forLocation location: Int) -> String.Index {
    return self.index(self.startIndex, offsetBy: location)
  }

  func lineStartIndex(beforeLocation location: Int) -> String.Index {
    return self.lineStartIndex(beforeIndex: self.index(forLocation: location))
  }

  func lineStartIndex(beforeIndex index: String.Index) -> String.Index {
    let range = self.rangeOfCharacter(from: CharacterSet.newlines,
                                      options: .backwards,
                                      range: (self.startIndex..<index))
    if let range = range,
       !range.isEmpty {
      return self.index(range.lowerBound, offsetBy: 1)
    }

    return self.startIndex
  }

  func indentation(from startIndex: String.Index,
                   withPrefix prefix: String? = nil) -> String? {
    let range = self.rangeOfCharacter(from: CharacterSet.whitespaces.inverted,
                                      range:(startIndex..<self.endIndex))
                ?? (startIndex..<startIndex)

    var rightBound = range.lowerBound
    if let prefix = prefix,
       range.lowerBound < self.endIndex {
      let subprefixEndIndex = self.index(range.lowerBound, offsetBy: prefix.count)
      if (prefix == self[range.lowerBound..<subprefixEndIndex]) {
        rightBound = subprefixEndIndex
      }
    }
    
    return rightBound > startIndex ? String(self[startIndex..<rightBound]) : nil
  }
}
