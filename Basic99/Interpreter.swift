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

    func interpret() throws -> Any {
        let tree = try self.parser.parse()
        return try visit(node: tree)
    }

    // MARK: - Private
    
    private func visit(node: ASTNode) throws -> Int {
        switch node {
        case let binaryOperationNode as ASTBinaryOperationNode:
            return try visit(binaryOperationNode: binaryOperationNode)
        case let numberNode as ASTNumberNode:
            return visit(numberNode: numberNode)
        case let unaryOperationNode as ASTUnaryOperationNode:
            return try visit(unaryOperationNode: unaryOperationNode)
        default: throw InterpreterError.invalidInput
        }
    }
    
    private func visit(binaryOperationNode: ASTBinaryOperationNode) throws -> Int {
        let left = try visit(node: binaryOperationNode.left)
        let right = try visit(node: binaryOperationNode.right)
        
        switch binaryOperationNode.operation {
        case .divide: return left / right
        case .plus: return left + right
        case .minus: return left - right
        case .multiply: return left * right
        default: fatalError()
        }
    }
    
    private func visit(unaryOperationNode: ASTUnaryOperationNode) throws -> Int {
        let result = try visit(node: unaryOperationNode.expression)
        
        switch unaryOperationNode.operation {            
        case .minus: return -(result)
        case .plus: return +(result)
        default: fatalError()
        }
    }
    
    private func visit(numberNode: ASTNumberNode) -> Int {
        return numberNode.value
    }
}
