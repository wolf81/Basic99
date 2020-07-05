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
    
    private func visit(node: ASTNode) throws -> Any {
        switch node {
        case let binaryOperationNode as ASTBinaryOperationNode:
            return try visit(binaryOperationNode: binaryOperationNode)
        case let numberNode as ASTNumberNode:
            return visit(numberNode: numberNode)
        default: throw InterpreterError.invalidInput
        }
    }
    
    private func visit(binaryOperationNode: ASTBinaryOperationNode) throws -> Int {
        let left = try visit(node: binaryOperationNode.left) as! Int
        let right = try visit(node: binaryOperationNode.right) as! Int
        
        switch binaryOperationNode.operation {
        case .divide: return left / right
        case .plus: return left + right
        case .minus: return left - right
        case .multiply: return left * right
        default: fatalError()
        }
    }
    
    private func visit(numberNode: ASTNumberNode) -> Int {
        return numberNode.value
    }
}
