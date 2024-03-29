//
//  Lexer.swift
//  Basic99
//
//  Created by Wolfgang Schreurs on 01/07/2020.
//  Copyright © 2020 Wolftrail. All rights reserved.
//

import Foundation

class Lexer {
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
    
    func nextToken() throws -> Token {
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
            case _ where character == "(":
                advance()
                return Token(type: .leftParenthesis)
            case _ where character == ")":
                advance()
                return Token(type: .rightParenthesis)
            default:
                throw InterpreterError.invalidInput
            }
        }
        
        return Token(type: .eof)
    }
    
    // MARK: - Private
            
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
}
