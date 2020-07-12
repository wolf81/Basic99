//
//  CharacterExtensions.swift
//  Basic99
//
//  Created by Wolfgang Schreurs on 29/06/2020.
//  Copyright © 2020 Wolftrail. All rights reserved.
//

import Foundation

extension Character {
    var isSpace: Bool { self == " " }
    
    var isAlpha: Bool { self.isASCII && self.isLetter }
    
    var isAlphaNumeric: Bool { self.isASCII && (self.isLetter || self.isNumber) }
    
    var isDigit: Bool { self.isASCII && self.isNumber }
}
