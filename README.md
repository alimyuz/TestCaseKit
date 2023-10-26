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

# Installation
#### Step 1
To install TestCaseKit in Xcode go to your project settings, click `Package Dependencies` > `+` > Enter https://github.com/alimyuz/TestCaseKit in the search bar, add the package to your test target.

**OR** simply add the following dependency to your Package.swift file:
```swift
dependencies: [
  .package(url: "https://github.com/alimyuz/TestCaseKit.git", .upToNextMajor(from: "1.0.0")),
]
```
#### Step 2
After the above steps you <ins>might</ins> get a warning in Issue Navigator. You need to click Trust the Library to procceed. After this step, you are good to go!

<img width="331" alt="Screenshot 2023-10-26 at 23 09 32" src="https://github.com/alimyuz/TestCaseKit/assets/45521753/31b542ab-0389-487a-9858-9aeff53bb179">

# Note
- Currently the external parameter name in test functions should be ommitted for the attribute to work (see [Example above](#Example)).
- Do not pass nil without specifying the desired argument type. 
```swift
@testCase(nil) // won't work
@testCase(nil as String?) // will work
```
