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
    
    init(text: String) {
        self.text = text
        self.position = 0
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
        default: throw InterpreterError.invalidInput
        }
                
        let right = self.currentToken
        try remove(.decimal)
        
        switch operation.type {
        case .plus: return (left.value as! Int) + (right.value as! Int)
        case .minus: return (left.value as! Int) - (right.value as! Int)
        default: throw InterpreterError.invalidInput
        }
    }
    
    private func nextToken() throws -> Token {
        guard self.position < self.text.count else { return Token(type: .eof) }
        
        let characterString = self.text[self.position ..< (self.position + 1)]
        guard characterString != " " else {
            self.position += 1
            return try nextToken()
        }
        
        let character = Character(characterString)
        if character.isASCII && character.isNumber {
            var valueString = characterString
            while true {
                if self.position == (self.text.count - 1) { break }
                
                let nextCharacterString = self.text[(self.position + 1) ..< (self.position + 2)]
                let nextCharacter = Character(nextCharacterString)
                if nextCharacter.isASCII && nextCharacter.isNumber {
                    valueString += nextCharacterString
                    self.position += 1
                } else {
                    break
                }
            }
            
            // if next character is also a number, append, otherwise return decimal value
            let value = Int(valueString)!
            self.position += 1
            return Token(type: .decimal, value: value)
        }
        
        switch character {
        case "+":
            self.position += 1
            return Token(type: .plus)
        case "-":
            self.position += 1
            return Token(type: .minus)
        default:
            throw InterpreterError.invalidInput
        }
    }
}
