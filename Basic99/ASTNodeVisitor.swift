//
//  ASTNodeVisitor.swift
//  Basic99
//
//  Created by Wolfgang Schreurs on 06/07/2020.
//  Copyright © 2020 Wolftrail. All rights reserved.
//

import Foundation

enum ASTNodeVisitorError: LocalizedError {
    case noVisitMethod
        
    var errorDescription: String? {
        switch self {
        case .noVisitMethod: return " ** NO VISIT METHOD **"
        }
    }
}

//class ASTNodeVisitor {
//    func visit<T>(node: ASTNode) -> T {
//        
//    }
//}
