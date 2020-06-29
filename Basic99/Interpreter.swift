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
    let text: String
    var position: Int
    var currentToken: Token = Token(type: .eof)
    var currentCharacter: Character?
    
    init(text: String) {
        self.text = text
        self.position = 0
        
        if self.text.count > 0 {
            let characterString = self.text[self.position ..< (self.position + 1)]
            self.currentCharacter = Character(characterString)
        }
    }
    
    func remove(_ tokenType: TokenType) throws {
        if self.currentToken.type == tokenType {
            self.currentToken = try nextToken()
        } else {
            throw InterpreterError.invalidInput
        }
    }
    
    func expression() throws -> Any {
        self.currentToken = try nextToken()
        
        let left = self.currentToken
        try remove(.decimal)
        
        let operation = self.currentToken
        switch operation.type {
        case .plus: try remove(.plus)
        case .minus: try remove(.minus)
        case .multiply: try remove(.multiply)
        case .divide: try remove(.divide)
        default: throw InterpreterError.invalidInput
        }
                
        let right = self.currentToken
        try remove(.decimal)
        
        switch operation.type {
        case .plus: return (left.value as! Int) + (right.value as! Int)
        case .minus: return (left.value as! Int) - (right.value as! Int)
        case .multiply: return (left.value as! Int) * (right.value as! Int)
        case .divide: return (left.value as! Int) / (right.value as! Int)
        default: throw InterpreterError.invalidInput
        }
    }
    
    private func advance() {
        self.position += 1
        
        if self.position > (self.text.count - 1) {
            self.currentCharacter = nil
        } else {
            let characterString = self.text[self.position ..< (self.position + 1)]
            self.currentCharacter = Character(characterString)
        }
    }
    
    private func skipWhitespace() {
        if let character = self.currentCharacter, character.isSpace {
            advance()
        }
    }
    
    private func intValue() -> Int {
        var result = ""
        while let character = self.currentCharacter, character.isDigit {
            result += String(character)
            advance()
        }
        
        return Int(result)!
    }
    
    private func nextToken() throws -> Token {
        guard self.position < self.text.count else { return Token(type: .eof) }
        
        while let character = self.currentCharacter {
            switch character {
            case _ where character.isSpace:
                skipWhitespace()
                continue
            case _ where character.isDigit:
                return Token(type: .decimal, value: self.intValue())
            case _ where character == "+":
                advance()
                return Token(type: .plus)
            case _ where character == "-":
                advance()
                return Token(type: .minus)
            case _ where character == "*":
                advance()
                return Token(type: .multiply)
            case _ where character == "/":
                advance()
                return Token(type: .divide)
            default:
                throw InterpreterError.invalidInput
            }
        }
        
        return Token(type: .eof)
    }
}
