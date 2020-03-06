//
//  DocumentModel.swift
//  TextEditor
//
//  Created by Артём Никифоров on 3/3/20.
//  Copyright © 2020 firexpl. All rights reserved.
//

import UIKit

class DocumentModel : NSObject, UITextViewDelegate {
  var tabCharacter : String = "\t"
  var bulletPointCharacter: String = "•"

  func insertTabCharacter(toTextView textView: UITextView) {
    if let selectedRange = textView.selectedTextRange {
      textView.replace(selectedRange, withText: tabCharacter)
    }
  }

  func insertBulletPoint(toTextView textView: UITextView) {
    if let selectedRange = textView.selectedTextRange {
      let location = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
      let lineStart = textView.text.lineStartIndex(beforeLocation: location)
      let indentation = textView.text.indentation(from: lineStart,
                                                  withPrefix: bulletPointCharacter)
//      if indentation

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

  func textViewDidChange(_ textView: UITextView) {

  }

  func textViewDidChangeSelection(_ textView: UITextView) {

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

  func line(beforeLocation location: Int) -> String? {
    guard location != 0 else {
      return nil
    }

    let locationIndex = self.index(forLocation: location)
    let lineStartIndex = self.lineStartIndex(beforeIndex: locationIndex)
    return String(self[lineStartIndex..<locationIndex])
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
