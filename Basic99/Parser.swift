//
//  Parser.swift
//  Basic99
//
//  Created by Wolfgang Schreurs on 06/07/2020.
//  Copyright © 2020 Wolftrail. All rights reserved.
//

import Foundation

class Parser {
    let lexer: Lexer
    var currentToken: Token = Token(type: .eof)
    
    init(lexer: Lexer) throws {
        self.lexer = lexer
        self.currentToken = try self.lexer.nextToken()
    }
    
    func parse() throws -> ASTNode {
        return try expression()
    }
    
    // MARK: - Private
    
    private func program() throws -> ASTCompoundNode {
        return ASTCompoundNode(children: try statementList())
    }

    private func factor() throws -> ASTNode {
        let token = self.currentToken
        
        switch token.type {
        case .plus:
            try remove(.plus)
            let node = try factor()
            return ASTUnaryOperationNode(token: token, expression: node)
        case .minus:
            try remove(.minus)
            let node = try factor()
            return ASTUnaryOperationNode(token: token, expression: node)
        case .decimal:
            try remove(.decimal)
            return ASTNumberNode(token: token)
        case .leftParenthesis:
            try remove(.leftParenthesis)
            let result = try expression()
            try remove(.rightParenthesis)
            return result
        case .id:
            return try variable()
        default: throw InterpreterError.invalidInput
        }
    }
    
    private func statementList() throws -> [ASTNode] {
        let node = try statement()
        var nodes: [ASTNode] = [node]
        
        while self.currentToken.type == .semicolon {
            try remove(.semicolon)
            nodes.append(try statement())
        }
        
        if self.currentToken.type == .id {
            print("handle properly")
            throw InterpreterError.invalidInput
        }
        
        return nodes
    }
    
    private func statement() throws -> ASTNode {
        switch self.currentToken.type {
        case .id:
            return try assignmentStatement()
        default:
            return empty()
        }
    }    
    
    private func assignmentStatement() throws -> ASTAssignNode {
        let left = try variable()
        let token = self.currentToken
        try remove(.assign)
        let right = try expression()
        let node = ASTAssignNode(token: token, left: left, right: right)
        return node
    }
    
    private func empty() -> ASTNoOperationNode {
        return ASTNoOperationNode(token: self.currentToken)
    }
    
    private func variable() throws -> ASTNode {
        let node = ASTVarNode(token: self.currentToken)
        try remove(.id)
        return node
    }
    
    private func term() throws -> ASTNode {
        var node = try factor()
        
        while self.currentToken.type.isTermOperation {
            let token = self.currentToken
            
            switch self.currentToken.type {
            case .multiply: try remove(.multiply)
            case .divide: try remove(.divide)
            default: fatalError()
            }
            
            let rightNode = try self.factor()
            node = ASTBinaryOperationNode(token: token, left: node, right: rightNode)
        }
        
        return node
    }
    
    private func expression() throws -> ASTNode {
        var node = try term()

        while self.currentToken.type.isExpressionOperation {
            let token = self.currentToken
            switch self.currentToken.type {
            case .plus: try remove(.plus)
            case .minus: try remove(.minus)
            default: fatalError()
            }
            
            let rightNode = try self.term()
            node = ASTBinaryOperationNode(token: token, left: node, right: rightNode)
        }
        
        return node
    }
        
    private func remove(_ tokenType: TokenType) throws {
        if self.currentToken.type == tokenType {
            self.currentToken = try self.lexer.nextToken()
        } else {
            throw InterpreterError.invalidInput
        }
    }
}
