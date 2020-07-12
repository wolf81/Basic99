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
            print("\(character) -> \(character.asciiValue)")
            switch character {
            case _ where character.isAlpha:
                return id()
                
            case _ where character.isSpace:
                skipWhitespace()
                continue
            case _ where character.isDigit:
                return Token(type: .decimal, value: self.intValue())
            case _ where character == "=":
                advance()
                return Token(type: .assign)
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
            case _ where character.asciiValue == 41:
                advance()
                return Token(type: .rightParenthesis)
            default:
                throw InterpreterError.invalidInput
            }
        }
        
        return Token(type: .eof)
    }
    
    // MARK: - Private
    
    private func peek() -> Character? {
        let position = self.position + 1

        if position > (self.text.count - 1) {
            return nil
        } else {
            let characterString = self.text[position ..< (position + 1)]
            return Character(characterString)
        }
    }
            
    private func advance() {
        self.position += 1
        
        if self.position > (self.text.count - 1) {
            self.currentCharacter = nil
        } else {
            let charIndex = self.text.utf8.index(self.text.startIndex, offsetBy: self.position)
            let charString = self.text[charIndex]
//             = self.text[self.position ..< (self.position + 1)]
            print("advance: \(charString)")
            self.currentCharacter = charString
        }
    }
    
    private func skipWhitespace() {
        if let character = self.currentCharacter, character.isSpace {
            advance()
        }
    }
    
    private func id() -> Token {
        var characters = Array<Character>()
        
        while let character = self.currentCharacter, character.isAlphaNumeric {
            characters.append(character)
            advance()
        }
                
        return Token(type: .id, value: String(characters))
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
