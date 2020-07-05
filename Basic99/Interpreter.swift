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
    let lexer: Lexer
//    var position: Int
    var currentToken: Token = Token(type: .eof)
//    var currentCharacter: Character?
    
    init(lexer: Lexer) throws {
        self.lexer = lexer
        self.currentToken = try self.lexer.nextToken()        
    }
    
    func factor() throws -> Int {
        let token = self.currentToken
        
        if token.type == .decimal {
            try remove(.decimal)
            return token.value as! Int
        } else if token.type == .leftParenthesis {
            try remove(.leftParenthesis)
            let result = try self.expression()
            try remove(.rightParenthesis)
            return result as! Int
        } else {
            throw InterpreterError.invalidInput
        }
    }
    
    func term() throws -> Int {
        var result = try factor()
        
        let termOperations: [TokenType] = [.multiply, .divide]
        while termOperations.contains(currentToken.type) {
            switch self.currentToken.type {
            case .multiply:
                try remove(.multiply)
                result = result * (try self.factor())
            case .divide:
                try remove(.divide)
                result = result / (try self.factor())
            default: fatalError()
            }
        }
        
        return result
    }
    
    func expression() throws -> Any {
        var result = try term()

        let expressionOperations: [TokenType] = [.plus, .minus]
        while expressionOperations.contains(self.currentToken.type) {
            switch self.currentToken.type {
            case .plus:
                try remove(.plus)
                result = result + (try self.term())
            case .minus:
                try remove(.minus)
                result = result - (try self.term())
            default: fatalError()
            }
        }
        
        return result
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
