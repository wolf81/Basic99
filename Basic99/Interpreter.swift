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
    case invalidName
        
    var errorDescription: String? {
        switch self {
        case .invalidInput: return " ** INVALID INPUT **"
        case .invalidName: return " ** INVALID NAME **"
        }
    }
}

class Interpreter {
    private let parser: Parser
    
    private var variables: [String: Int] = [:]
    
    init(parser: Parser) {
        self.parser = parser
    }

    func interpret() throws -> Int? {
        let tree = try self.parser.parse()
        return try visit(node: tree)
    }

    // MARK: - Private
    
    private func visit(node: ASTNode) throws -> Int? {
        switch node {
        case let binaryOperationNode as ASTBinaryOperationNode:
            return try visit(binaryOperationNode: binaryOperationNode)
        case let numberNode as ASTNumberNode:
            return visit(numberNode: numberNode)
        case let unaryOperationNode as ASTUnaryOperationNode:
            return try visit(unaryOperationNode: unaryOperationNode)
        case let compoundNode as ASTCompoundNode:
            return try visit(compoundNode: compoundNode)
        case let assignmentNode as ASTAssignNode:
            try visit(assignmentNode: assignmentNode)
        case let noOperationNode as ASTNoOperationNode:
            visit(noOperationNode: noOperationNode)
        case let variableNode as ASTVarNode:
            return try visit(variableNode: variableNode)
        default: throw InterpreterError.invalidInput
        }
                        
        return nil
    }
    
    private func visit(binaryOperationNode: ASTBinaryOperationNode) throws -> Int {
        let left = try visit(node: binaryOperationNode.left)!
        let right = try visit(node: binaryOperationNode.right)!
        
        switch binaryOperationNode.operation {
        case .divide: return left / right
        case .plus: return left + right
        case .minus: return left - right
        case .multiply: return left * right
        default: fatalError()
        }
    }
    
    private func visit(variableNode: ASTVarNode) throws -> Int {
        let variableName = variableNode.value as! String
        guard let value = self.variables[variableName] else {
            throw InterpreterError.invalidName
        }
        
        return value
    }
    
    private func visit(assignmentNode: ASTAssignNode) throws {
        let varName = assignmentNode.left.token.value as! String
        let value = try visit(node: assignmentNode.right)!
        self.variables[varName] = value
    }
    
    private func visit(noOperationNode: ASTNoOperationNode) {
        
    }
    
    private func visit(compoundNode: ASTCompoundNode) throws -> Int? {
        for child in compoundNode.children {
            return try visit(node: child)
        }
        
        return nil
    }
    
    private func visit(unaryOperationNode: ASTUnaryOperationNode) throws -> Int {
        let result = try visit(node: unaryOperationNode.expression)!
        
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
