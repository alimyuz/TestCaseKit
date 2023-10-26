import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import TestCasesMacroMacros
import TestCasesMacro

let testMacros: [String: Macro.Type] = [
    "testCase": TestCaseMacro.self,
]

final class TestCasesMacroTests: XCTestCase {
    func testMacroSingleIntArgument() {
        assertMacroExpansion(
            """
            class Example {
                @testCase(987)
                func test(_ param: Int) {
                    print(param)
                }
            }
            """,
            expandedSource: """
            class Example {
                func test(_ param: Int) {
                    print(param)
                }
            
                func test_case1() {
                    self.test(987)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroSingleStringArgument() {
        assertMacroExpansion(
            """
            class Example {
                @testCase("PPQQ")
                func test(_ param: String) {
                    print(param)
                }
            }
            """,
            expandedSource: """
            class Example {
                func test(_ param: String) {
                    print(param)
                }
            
                func test_case1() {
                    self.test("PPQQ")
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMacroSingleDoubleArgument() {
        assertMacroExpansion(
            """
            class Example {
                @testCase(2.521)
                func test(_ param: Double) {
                    print(param)
                }
            }
            """,
            expandedSource: """
            class Example {
                func test(_ param: Double) {
                    print(param)
                }
            
                func test_case1() {
                    self.test(2.521)
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMacroMultipleIntArguments() {
        assertMacroExpansion(
            """
            class Example {
                @testCase(3, 4, 5)
                func test(_ param: Int, _ param2: Int, _ param3: Int) {
                    print(param)
                }
            }
            """,
            expandedSource: """
            class Example {
                func test(_ param: Int, _ param2: Int, _ param3: Int) {
                    print(param)
                }
            
                func test_case1() {
                    self.test(3, 4, 5)
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMacroMultipleDifferentTypeArguments() {
        assertMacroExpansion(
            """
            class Example {
                @testCase("One", 4, 5)
                func test(_ param: String, _ param2: Int, _ param3: Int) {
                    print(param)
                }
            }
            """,
            expandedSource: """
            class Example {
                func test(_ param: String, _ param2: Int, _ param3: Int) {
                    print(param)
                }

                func test_case1() {
                    self.test("One", 4, 5)
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMacroMultipleTestCases() {
        assertMacroExpansion(
            """
            class Example {
                @testCase("One", 4, 5)
                @testCase("Two", 6, 7)
                func test(_ param: String, _ param2: Int, _ param3: Int) {
                    print(param)
                }
            }
            """,
            expandedSource: """
            class Example {
                func test(_ param: String, _ param2: Int, _ param3: Int) {
                    print(param)
                }

                func test_case1() {
                    self.test("One", 4, 5)
                }

                func test_case2() {
                    self.test("Two", 6, 7)
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testAssertDiagnosticTooManyArguments() {
        assertMacroExpansion(
            """
            class Example {
                @testCase("One", 4, 5, 6)
                func test(_ param: String, _ param2: Int, _ param3: Int) {
                    print(param)
                }
            }
            """,
            expandedSource:
            """
            class Example {
                func test(_ param: String, _ param2: Int, _ param3: Int) {
                    print(param)
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Too many arguments. Expected: 3, provided: 4", line: 2, column: 5)
            ],
            macros: testMacros
        )
    }
    
    func testAssertDiagnosticTooLittleArguments() {
        assertMacroExpansion(
            """
            class Example {
                @testCase("One")
                func test(_ param: String, _ param2: Int, _ param3: Int) {
                    print(param)
                }
            }
            """,
            expandedSource:
            """
            class Example {
                func test(_ param: String, _ param2: Int, _ param3: Int) {
                    print(param)
                }
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "Missing arguments. Expected: 3, provided: 1", line: 2, column: 5)
            ],
            macros: testMacros
        )
    }
    
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
