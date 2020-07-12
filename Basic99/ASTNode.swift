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
    
    init(token: Token, left: ASTNode, right: ASTNode) {
        self.left = left
        self.right = right

        super.init(token: token)
    }
}

class ASTNumberNode: ASTNode {
    var value: Int { self.token.value as! Int }
}

class ASTUnaryOperationNode: ASTNode {
    var operation: TokenType { self.token.type }
    
    let expression: ASTNode
    
    init(token: Token, expression: ASTNode) {
        self.expression = expression
        
        super.init(token: token)
    }
}

class ASTVarNode: ASTNode {
    var value: Any { self.token.value as Any }
    
    override init(token: Token) {
        super.init(token: token)
    }
}

class ASTNoOperationNode: ASTNode {    
}

class ASTCompoundNode: ASTNode {
    let children: [ASTNode]
    
    init(children: [ASTNode]) {
        self.children = children
        
        let dummyToken = Token(type: .semicolon)
        super.init(token: dummyToken)
    }
}

class ASTAssignNode: ASTNode {
    var operation: TokenType { self.token.type }
    
    let left: ASTNode
    let right: ASTNode
    
    init(token: Token, left: ASTNode, right: ASTNode) {
        self.left = left
        self.right = right
        
        super.init(token: token)
    }
}
