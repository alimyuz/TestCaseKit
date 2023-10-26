import TestCasesMacro


class Example {
    
    @testCase(1)
    func test(_ param: Int) {
        print(param)
    }
    
    @testCase("OOO")
    @testCase("iii")
    func someName(_ value: String) {
        print(value)
    }
}


Example().test_case1()  // prints 1
Example().someName_case1()  // prints OOO
Example().someName_case2()  // prints iii
