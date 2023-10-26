//
//  File.swift
//  
//
//  Created by Alim Yuzbashev on 13.06.2023.
//

import Foundation


public enum TestCaseMacroError: Error, CustomDebugStringConvertible {
    
    case notSupported
    case tooManyArguments(expected: Int, actual: Int)
    case tooLittleArguments(expected: Int, actual: Int)
    
    public var debugDescription: String {
        switch self {
        case .notSupported:
            "@testCases attribute can only be applied to functions"
        case .tooManyArguments(expected: let expected, actual: let actual):
            "Too many arguments. Expected: \(expected), provided: \(actual)"
        case .tooLittleArguments(expected: let expected, actual: let actual):
            "Missing arguments. Expected: \(expected), provided: \(actual)"
        }
    }
}
