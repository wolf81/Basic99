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
//    var position: Int
    var currentToken: Token = Token(type: .eof)
//    var currentCharacter: Character?
    
    init(lexer: Lexer) throws {
        self.lexer = lexer
        self.currentToken = try self.lexer.nextToken()
    }
    
    func parse() throws -> ASTNode {
        return try self.expression()
    }
    
    func factor() throws -> ASTNode {
        let token = self.currentToken
        
        if token.type == .decimal {
            try remove(.decimal)
            return ASTNumberNode(token: token)
        } else if token.type == .leftParenthesis {
            try remove(.leftParenthesis)
            let result = try self.expression()
            try remove(.rightParenthesis)
            return result
        } else {
            throw InterpreterError.invalidInput
        }
    }
    
    func term() throws -> ASTNode {
        var node = try factor()
        
        while self.currentToken.type.isTermOperation {
            let token = self.currentToken
            
            switch self.currentToken.type {
            case .multiply: try remove(.multiply)
            case .divide: try remove(.divide)
            default: fatalError()
            }
            
            let rightNode = try self.factor()
            node = ASTBinaryOperationNode(operation: token, left: node, right: rightNode)
        }
        
        return node
    }
    
    func expression() throws -> ASTNode {
        var node = try term()

        while self.currentToken.type.isExpressionOperation {
            let token = self.currentToken
            switch self.currentToken.type {
            case .plus: try remove(.plus)
            case .minus: try remove(.minus)
            default: fatalError()
            }
            
            let rightNode = try self.term()
            node = ASTBinaryOperationNode(operation: token, left: node, right: rightNode)
        }
        
        return node
    }
    
    // MARK: - Private
    
    private func remove(_ tokenType: TokenType) throws {
        if self.currentToken.type == tokenType {
            self.currentToken = try self.lexer.nextToken()
        } else {
            throw InterpreterError.invalidInput
        }
    }
}
