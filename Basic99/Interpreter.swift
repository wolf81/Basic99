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
        try remove(.decimal)
        return token.value as! Int
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
        
//    private func advance() {
//        self.position += 1
//
//        if self.position > (self.text.count - 1) {
//            self.currentCharacter = nil
//        } else {
//            let characterString = self.text[self.position ..< (self.position + 1)]
//            self.currentCharacter = Character(characterString)
//        }
//    }
//
//    private func skipWhitespace() {
//        if let character = self.currentCharacter, character.isSpace {
//            advance()
//        }
//    }
//
//    private func intValue() -> Int {
//        var result = ""
//        while let character = self.currentCharacter, character.isDigit {
//            result += String(character)
//            advance()
//        }
//
//        return Int(result)!
//    }
//
//    private func nextToken() throws -> Token {
//        guard self.position < self.text.count else { return Token(type: .eof) }
//
//        while let character = self.currentCharacter {
//            switch character {
//            case _ where character.isSpace:
//                skipWhitespace()
//                continue
//            case _ where character.isDigit:
//                return Token(type: .decimal, value: self.intValue())
//            case _ where character == "+":
//                advance()
//                return Token(type: .plus)
//            case _ where character == "-":
//                advance()
//                return Token(type: .minus)
//            case _ where character == "*":
//                advance()
//                return Token(type: .multiply)
//            case _ where character == "/":
//                advance()
//                return Token(type: .divide)
//            default:
//                throw InterpreterError.invalidInput
//            }
//        }
//
//        return Token(type: .eof)
//    }
}
