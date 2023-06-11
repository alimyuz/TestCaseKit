@attached(peer, names: overloaded)
public macro testCase<each T>(_: repeat each T) = #externalMacro(module: "TestCasesMacroMacros", type: "TestCaseMacro")
