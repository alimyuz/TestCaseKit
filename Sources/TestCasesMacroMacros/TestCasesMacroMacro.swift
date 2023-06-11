import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public enum TestCaseMacroError: Error {
    
    case notSupported
}

public struct TestCaseMacro: PeerMacro {
    
    private static var alreadyExpandedForFunctions = Set<SyntaxIdentifier>()
    
    public static func expansion<Context, Declaration>(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] where Context : MacroExpansionContext, Declaration : DeclSyntaxProtocol {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw TestCaseMacroError.notSupported
        }
        // Check if the macro has already been expanded for this function
        let funcIdentifier = funcDecl.identifier.text
        guard !self.alreadyExpandedForFunctions.contains(funcDecl.id) else {
            return []
        }
        self.alreadyExpandedForFunctions.insert(funcDecl.id)
        
        // Construct expressions from all @testCase attributes
        let expressions = self.testCaseAttributes(for: funcDecl).map { attribute in
            self.argumentCallList(for: attribute)
        }.map { arguments in
            ExprSyntax("self.\(raw: funcIdentifier)(\(raw: arguments))")
        }
        
        // Construct function itself
        let newFuncHeader = PartialSyntaxNodeString(stringLiteral: "func \(funcIdentifier)()")
        let items = expressions.map { CodeBlockItemSyntax(item: .expr($0)) }
        let newFuncDecl = try FunctionDeclSyntax(newFuncHeader) {
            CodeBlockItemListSyntax(items)
        }
        
        // Convert
        return [newFuncDecl.as(DeclSyntax.self)!]
    }
    
    // Finds @testCase attributes from all attributes of a function
    private static func testCaseAttributes(
        for function: FunctionDeclSyntax
    ) -> [AttributeListSyntax.Element] {
        function.attributes?.filter { attribute in
            switch attribute {
            case .attribute(let attribute):
                return attribute.attributeName.firstToken(viewMode: .sourceAccurate)?.text == "testCase"
            default:
                return false
            }
        } ?? []
    }
    
    // Converts @testCase attribute to argument list for calling a function
    // E.g. @testCase("a", 2, 0.5) -> "a", 2, 0.5
    private static func argumentCallList(
        for attribute: AttributeListSyntax.Element
    ) -> String {
        switch attribute {
        case .attribute(let attribute):
            switch attribute.argument {
            case .argumentList(let list):
                return self.argumentCallList(from: list)
            default:
                fatalError(attribute.debugDescription) // Idk when this happens
            }
        case .ifConfigDecl:
            fatalError(attribute.debugDescription) // should never happen
        }
    }
    
    // Converts tuple expression to argument list for calling a function
    // E.g. ("a", 2, 0.5) -> "a", 2, 0.5
    private static func argumentCallList(
        from argumentList: TupleExprElementListSyntax
    ) -> String {
        argumentList.map { expression in
            expression.tokens(viewMode: .sourceAccurate)
                .reduce("") { $0 + $1.text }
        }.joined(separator: " ")
    }
}

@main
struct TestCasesMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TestCaseMacro.self,
    ]
}
