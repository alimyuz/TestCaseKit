import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import OSLog

extension String : Error { }
public struct TestCaseMacro: PeerMacro {
    
    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] where Context : MacroExpansionContext, Declaration : DeclSyntaxProtocol {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw TestCaseMacroError.notSupported
        }
        
        // Index value is unavailable in the API,
        // so we retreieve it from node location in source file.
        // Update when/if it becomes publicly available.
        let nodeLocation = context.location(of: node)?.line.as(IntegerLiteralExprSyntax.self)?.literal.text ?? "0"
        let funcDeclLocation = context.location(of: funcDecl)?.line.as(IntegerLiteralExprSyntax.self)?.literal.text ?? "0"
        let testIndex = (Int(nodeLocation) ?? 0) - (Int(funcDeclLocation) ?? 0) + 1
        
        // Retrieve argument list in the given attribute
        let arguments = try self.argumentCallList(of: node, for: funcDecl)
        
        // Construct new test function
        let funcIdentifier = funcDecl.name.text
        
        // Construct function body
        let newFuncHeader = SyntaxNodeString(
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
    ) throws -> LabeledExprListSyntax {
        switch attribute.arguments {
        case .argumentList(let list):
            let expectedParametersCount = function.signature.parameterClause.parameters.count
            if list.count > expectedParametersCount {
                throw TestCaseMacroError.tooManyArguments(expected: expectedParametersCount, actual: list.count)
            } else if list.count < expectedParametersCount {
                throw TestCaseMacroError.tooLittleArguments(expected: expectedParametersCount, actual: list.count)
            } else {
                return list
            }
        default:
            throw "Not an argument list. \(attribute.debugDescription)" // Should not happen
        }
    }
}

@main
struct TestCasesMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TestCaseMacro.self,
    ]
}
