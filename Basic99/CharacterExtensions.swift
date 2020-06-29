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
    
    var isDigit: Bool { self.isASCII && self.isNumber }
}
