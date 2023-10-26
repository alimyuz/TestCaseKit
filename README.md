# TestCaseKit
TestCaseKit is a Swift Macro that lets you create test cases with arguments, without needing to create separate tests for each set of arguments.

# Example
```swift
@testCase(3, 1, 4)
@testCase(5, 3, 8)
@testCase(6, 12, 18)
func testSumNumbers(_ lhs: Int, _ rhs: Int, _ result: Int) {
  XCTAssertEqual(lhs + rhs, result)
}

@testCase("1", "1", "11")
@testCase("5", "3", "53")
@testCase("6", "12", "612")
func testConcatStrings(_ lhs: String, _ rhs: String, _ result: String) {
  XCTAssertEqual(lhs + rhs, result)
}

@testCase(nil as String?)
func testOptional(_ x: String?) {
  XCTAssertNil(x)
}
```

# Usage

To use TestCaseKit, simply import the library into your test project and add the `@testCase` attribute to your test function. The @testCase attribute takes a variable number of arguments, which will be passed to the test case as arguments.

### Fully integrated in Xcode
<img width="732" alt="Screenshot 2023-10-26 at 22 30 00" src="https://github.com/alimyuz/Swift-TestCasesMacro/assets/45521753/19ce31da-3b15-4b17-b11f-480247b8ca5b">
<img width="237" alt="Screenshot 2023-10-26 at 22 30 28" src="https://github.com/alimyuz/Swift-TestCasesMacro/assets/45521753/795c2774-b757-4260-a958-42959e6c0175">



# Note
- Currently the external parameter name in test functions should be ommitted for the attribute to work (see [Example above](#Example)).
- Do not pass nil without specifying the desired argument type. 
```swift
@testCase(nil) // won't work
@testCase(nil as String?) // will work
```
