//
//  ASTNode.swift
//  Basic99
//
//  Created by Wolfgang Schreurs on 05/07/2020.
//  Copyright © 2020 Wolftrail. All rights reserved.
//

import Foundation

class ASTNode {
    let token: Token
    
    init(token: Token) {
        self.token = token
    }
}

class ASTBinaryOperationNode: ASTNode {
    var operation: TokenType { self.token.type }
    
    let left: ASTNode
    let right: ASTNode
    
    init(operation: Token, left: ASTNode, right: ASTNode) {
        self.left = left
        self.right = right

        super.init(token: operation)
    }
}

class ASTNumberNode: ASTNode {
    var value: Int { self.token.value as! Int }
}
