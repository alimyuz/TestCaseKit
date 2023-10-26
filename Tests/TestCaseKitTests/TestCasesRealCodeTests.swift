//
//  TestCasesRealCodeTests.swift
//
//
//  Created by Alim Yuzbashev on 26.10.2023.
//

import XCTest
import TestCaseKit

final class TestCasesRealCodeTests: XCTestCase {
    
    @testCase(3, 1, 4)
    @testCase(5, 3, 8)
    @testCase(6, 12, 18)
    func testRealCodeMacroSum(_ lhs: Int, _ rhs: Int, _ result: Int) {
        XCTAssertEqual(lhs + rhs, result)
    }
    
    @testCase("1", "1", "11")
    @testCase("5", "3", "53")
    @testCase("6", "12", "612")
    func testRealCodeMacroSumStrings(_ lhs: String, _ rhs: String, _ result: String) {
        XCTAssertEqual(lhs + rhs, result)
    }
    
    @testCase(nil as String?)
    func testRealCodeMacroOptional(_ x: String?) {
        XCTAssertNil(x)
    }
}
