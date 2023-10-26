@attached(peer, names: arbitrary)
public macro testCase<each T>(_: repeat each T) = #externalMacro(module: "TestCaseKitMacros", type: "TestCaseMacro")
