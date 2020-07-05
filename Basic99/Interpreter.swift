//
//  Interpreter.swift
//  Basic99
//
//  Created by Wolfgang Schreurs on 29/06/2020.
//  Copyright © 2020 Wolftrail. All rights reserved.
//

import Foundation

enum InterpreterError: LocalizedError {
    case invalidInput
        
    var errorDescription: String? {
        switch self {
        case .invalidInput: return " ** INVALID INPUT **"
        }
    }
}

class Interpreter {
    private let parser: Parser
    
    init(parser: Parser) {
        self.parser = parser
    }
        
    private func visit(node: ASTNode) throws -> Any {
        switch node {
        case let binaryOperationNode as ASTBinaryOperationNode:
            let left = try visit(node: binaryOperationNode.left) as! Int
            let right = try visit(node: binaryOperationNode.right) as! Int
            
            switch binaryOperationNode.operation {
            case .divide: return left / right
            case .plus: return left + right
            case .minus: return left - right
            case .multiply: return left * right
            default: throw InterpreterError.invalidInput
            }
        case let numberNode as ASTNumberNode:
            return numberNode.value
        default: throw InterpreterError.invalidInput
        }
    }
    
    func interpret() throws -> Any {
        let tree = try self.parser.parse()
        return try visit(node: tree)
    }
}
