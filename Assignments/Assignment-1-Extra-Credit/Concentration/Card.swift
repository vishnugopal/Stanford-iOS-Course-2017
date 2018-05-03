//
//  Card.swift
//  Concentration
//
//  Created by Vishnu Gopal on 30/04/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    static func resetIdentifiers() {
        identifierFactory = 0
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
