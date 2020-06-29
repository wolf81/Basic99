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
    while let line = readLine() {
        if line == "BYE" {
            break
        }

        let interpreter = Interpreter(text: line)
        do {
            let expression = try interpreter.expression()
            print(expression)
        } catch let error {
            print(error.localizedDescription)
        }

        print(">", terminator: "")
    }
}

main()

