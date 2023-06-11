import TestCasesMacro


class Example {
    
    @testCase(1)
    func test(_ param: Int) {
        print(param)
    }
    
    @testCase("OOO")
    func someName(_ value: String) {
        print(value)
    }
}


Example().test() // prints 1
Example().someName() // prints OOO
