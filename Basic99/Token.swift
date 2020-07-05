//
//  Token.swift
//  Basic99
//
//  Created by Wolfgang Schreurs on 29/06/2020.
//  Copyright © 2020 Wolftrail. All rights reserved.
//

import Foundation

enum TokenType {
    case decimal
//    case Real
    case plus
    case minus
    case multiply
    case divide
    case leftParenthesis
    case rightParenthesis
    case eof
    
    var isExpressionOperation: Bool {
        let expressionOperations: [TokenType] = [.plus, .minus]
        return expressionOperations.contains(self)
    }

    var isTermOperation: Bool {
        let termOperations: [TokenType] = [.multiply, .divide]
        return termOperations.contains(self)
    }
}

class Token {
    let type: TokenType
    let value: Any?
    
    init(type: TokenType, value: Any?) {
        self.type = type
        self.value = value
    }
    
    convenience init(type: TokenType) {
        self.init(type: type, value: nil)
    }    
}

extension Token: CustomStringConvertible {
    var description: String {
        return "Token(\(self.type), \(String(describing: self.value)))"
    }
}
