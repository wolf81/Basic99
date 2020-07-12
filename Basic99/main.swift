//
//  main.swift
//  Basic99
//
//  Created by Wolfgang Schreurs on 29/06/2020.
//  Copyright © 2020 Wolftrail. All rights reserved.
//

import Foundation

print(" TI BASIC READY")

func main() {
//    let token = Token(type: .Decimal, value: 1)
//    print("token: \(token)")
    
    print(">", terminator: "")
    while let line = readLine()?.uppercased() {
        if line == "BYE" {
            break
        }
        
        let lexer = Lexer(text: line)
        do {
            let parser = try Parser(lexer: lexer)
            let interpreter = Interpreter(parser: parser)
            if let result = try interpreter.interpret() {
                print("  \(result)")
            }            
        } catch let error {
            print(error.localizedDescription)
        }

        print(">", terminator: "")
    }
}

main()

