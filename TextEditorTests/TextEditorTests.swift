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

  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testStringLine() {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.
    let testString = "lorem ipsum\ndo something\n\n\nand nothing"
    let nsTestString = testString as NSString

    XCTAssert(testString.line(beforeLocation: 0) == nil)

    let commonCaseRange = nsTestString.range(of: "mething")
    let commonLine = testString.line(beforeLocation: commonCaseRange.location)
    XCTAssert(commonLine != nil)
    XCTAssert(commonLine! == "do so")


    let emptyLineRange = nsTestString.range(of: "and ")
    let emptyLine = testString.line(beforeLocation: emptyLineRange.location)
    XCTAssert(emptyLine != nil)
    XCTAssert(emptyLine! == "")

    let doubleEmptyLineRange = nsTestString.range(of: "\nand")
    let doubleEmptyLine = testString.line(beforeLocation: doubleEmptyLineRange.location)
    XCTAssert(doubleEmptyLine != nil)
    XCTAssert(doubleEmptyLine! == "")

    let firstLineRange = nsTestString.range(of: "ipsum")
    let firstLine = testString.line(beforeLocation: firstLineRange.location)
    XCTAssert(firstLine != nil)
    XCTAssert(firstLine! == "lorem ")

  }

  func testStringIndentation() {
    let testStrings = [
      "\t  text     dfjlajdf lks",
      "text without indentation",
      "   text with space only indentation",
      "\t\t\ttext with tabs\t only indentation",
      " \t\t \t text with mixed indentation",
      ""
    ]

    let results = [
      "\t  ",
      nil,
      "   ",
      "\t\t\t",
      " \t\t \t ",
      nil,
    ]

    XCTAssert(testStrings.count == results.count)

    for (index, test) in testStrings.enumerated() {
      let result = results[index]
      let indentation = test.indentation()
      let success = indentation == result
      if !success {
        print("indentation fail: expected \(String(describing: result)) | actual \(String(describing: indentation))")
      }
      XCTAssert(success)
    }

    let testPrefixStrings = [
      "•jdsf sdlfj asdfl ",
      "   •dsfkj dsfjl dfjal",
      "\t*•s'owefm djfljwo fw",
      "• \t\t\t",
      "•",
      ""
    ]

    let prefixResults = [
      "•",
      "   •",
      "\t",
      "•",
      "•",
      nil
    ]

    XCTAssert(testPrefixStrings.count == prefixResults.count)

    for (index, test) in testPrefixStrings.enumerated() {
      let result = prefixResults[index]
      let indentation = test.indentation(withPrefix: "•")
      let success = indentation == result
      if !success {
        print("indentation prefix fail: expected \(String(describing: result)) | actual \(String(describing: indentation))")
      }
      XCTAssert(success)
    }
  }
}
