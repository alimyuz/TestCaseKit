import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct TestCaseMacro: PeerMacro {
    
    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] where Context : MacroExpansionContext, Declaration : DeclSyntaxProtocol {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw TestCaseMacroError.notSupported
        }
        // Retrieve argument list in the given attribute
        let arguments = try self.argumentCallList(of: node, for: funcDecl)
        
        // Index value is unavailable in the API,
        // so we retreieve it directly from the memory.
        // Update when/if it becomes publicly available.
        var nodeIndex = node.index
        let testIndex = withUnsafeBytes(of: &nodeIndex) { bytes in
            bytes[4]
        } + 1
        
        // Construct new test function
        let funcIdentifier = funcDecl.identifier.text
        
        // Construct function body
        let newFuncHeader = PartialSyntaxNodeString(
            stringLiteral: "func \(funcIdentifier)_case\(testIndex)()")
        let newFuncDecl = try FunctionDeclSyntax(newFuncHeader) {
            ExprSyntax("self.\(raw: funcIdentifier)(\(raw: arguments))")
        }
        
        // Convert
        return [newFuncDecl.as(DeclSyntax.self)!]
    }
    
    // Converts @testCase attribute to argument list for calling a function
    // E.g. @testCase("a", 2, 0.5) -> "a", 2, 0.5
    private static func argumentCallList(
        of attribute: AttributeSyntax,
        for function: FunctionDeclSyntax
    ) throws -> TupleExprElementListSyntax {
        switch attribute.argument {
        case .argumentList(let list):
            let expectedParametersCount = function.signature.input.parameterList.count
            if list.count > expectedParametersCount {
                throw TestCaseMacroError.tooManyArguments(expected: expectedParametersCount, actual: list.count)
            } else if list.count < expectedParametersCount {
                throw TestCaseMacroError.tooLittleArguments(expected: expectedParametersCount, actual: list.count)
            } else {
                return list
            }
        default:
            fatalError(attribute.debugDescription) // Should not happen
        }
    }
}

@main
struct TestCasesMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TestCaseMacro.self,
    ]
}
