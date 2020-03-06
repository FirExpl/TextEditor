//
//  TextEditorTests.swift
//  TextEditorTests
//
//  Created by Артём Никифоров on 3/2/20.
//  Copyright © 2020 firexpl. All rights reserved.
//

import XCTest
@testable import TextEditor

class TextEditorTests: XCTestCase {

  var textViewManager : TextViewManager!
  var textView: UITextView!

  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
    textViewManager = TextViewManager()
    textView = UITextView()
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testTabFunction() {
    let testText = "lorem ipsum delle \namore"
    textView.text = testText
    let positionStart = textView.position(from: textView.beginningOfDocument, offset: 6)!
    let positionEnd = textView.position(from: textView.beginningOfDocument, offset: 11)!
    textView.selectedTextRange = textView.textRange(from: positionStart, to: positionEnd)
    textViewManager.insertTabCharacter(toTextView: textView)
    XCTAssert(textView.text == "lorem \(textViewManager.tabCharacter) delle \namore")

    textView.text = testText
    textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                    to: textView.beginningOfDocument)
    textViewManager.insertTabCharacter(toTextView: textView)
    XCTAssert(textView.text == "\(textViewManager.tabCharacter)lorem ipsum delle \namore")

    textView.text = testText
    textView.selectedTextRange = textView.textRange(from: textView.endOfDocument,
                                                    to: textView.endOfDocument)
    textViewManager.insertTabCharacter(toTextView: textView)
    XCTAssert(textView.text == "lorem ipsum delle \namore\(textViewManager.tabCharacter)")
  }

  func testBulletpointFunction() {
    let testText = "lorem ipsum delle \namore"
    textView.text = testText
    let positionStart = textView.position(from: textView.beginningOfDocument, offset: 6)!
    let positionEnd = textView.position(from: textView.beginningOfDocument, offset: 11)!
    textView.selectedTextRange = textView.textRange(from: positionStart, to: positionEnd)
    textViewManager.insertBulletPoint(toTextView: textView)
    XCTAssert(textView.text == "\(textViewManager.bulletPointCharacter)lorem ipsum delle \namore")

    // second press of bullet button should undo previous action
    textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                    to: textView.beginningOfDocument)
    textViewManager.insertBulletPoint(toTextView: textView)
    XCTAssert(textView.text == testText)

    // check that behavior still the same even for second line
    let slPositionStart = textView.position(from: textView.beginningOfDocument, offset: 20)!
    let slPositionEnd = textView.position(from: textView.beginningOfDocument, offset: 24)!
    textView.selectedTextRange = textView.textRange(from: slPositionStart, to: slPositionEnd)
    textViewManager.insertBulletPoint(toTextView: textView)
    XCTAssert(textView.text == "lorem ipsum delle \n\(textViewManager.bulletPointCharacter)amore")

    textView.selectedTextRange = textView.textRange(from: textView.endOfDocument,
                                                    to: textView.endOfDocument)
    textViewManager.insertBulletPoint(toTextView: textView)
    XCTAssert(textView.text == testText)
  }

  func testUITextViewDelegateMethods() {
    let testText = " \t lorem ipsum delle \namore"
    textView.text = testText
    // simulate the return button pressing by passing new line character as replacement text
    var shouldCnahge = textViewManager.textView(textView, shouldChangeTextIn: NSRange(location: 9, length: 5), replacementText: "\n")
    XCTAssert(!shouldCnahge)
    XCTAssert(textView.text == " \t lorem \n \t  delle \namore")

    let textBefore = textView.text!
    shouldCnahge = textViewManager.textView(textView, shouldChangeTextIn: NSRange(location: 9, length: 4), replacementText: "ipsum")
    XCTAssert(shouldCnahge)
    // textManager shouldn't change the text in case it returns true
    XCTAssert(textView.text == textBefore)
  }

  func testStringIndentation() {
    let testStrings = [
      "\t  text     dfjlajdf lks",
      "text without indentation",
      "   text with space only indentation",
      "\t\t\ttext with tabs\t only indentation",
      " \t\t \t text with mixed indentation",
      "",
      "text with newline\n  and indentation",
      "\n\tindentation should work",
      "in any case \n",
      "\n",
    ]

    let results = [
      "\t  ",
      nil,
      "   ",
      "\t\t\t",
      " \t\t \t ",
      nil,
      "  ",
      "\t",
      nil,
      nil,
    ]

    XCTAssert(testStrings.count == results.count)

    for (index, test) in testStrings.enumerated() {
      let result = results[index]
      let startIndex = test.lineStartIndex(beforeIndex: test.endIndex)
      let indentation = test.indentation(from:startIndex)
      XCTAssert(indentation == result,
                "indentation fail: expected \(String(describing: result)) | actual \(String(describing: indentation))")
    }
  }

  func testStringIndentationWithPrefix() {
    let testPrefixStrings = [
      "•jdsf sdlfj asdfl ",
      "   •dsfkj dsfjl dfjal",
      "\t*•s'owefm djfljwo fw",
      "• \t\t\t",
      "•",
      "",
      "text with newline\n  •and indentation",
      "\n\t•indentation should work",
      "in any case \n•",
      "•\n",
    ]

    let prefixResults = [
      "•",
      "   •",
      "\t",
      "•",
      "•",
      nil,
      "  •",
      "\t•",
      "•",
      nil,
    ]

    XCTAssert(testPrefixStrings.count == prefixResults.count)

    for (index, test) in testPrefixStrings.enumerated() {
      let result = prefixResults[index]
      let startIndex = test.lineStartIndex(beforeIndex: test.endIndex)
      let indentation = test.indentation(from: startIndex, withPrefix: "•")
      XCTAssert(indentation == result,
                "indentation prefix fail: expected \(String(describing: result)) | actual \(String(describing: indentation))")
    }
  }
}
