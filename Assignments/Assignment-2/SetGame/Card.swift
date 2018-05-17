//
//  Card.swift
//  SetGame
//
//  Created by Vishnu Gopal on 17/05/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import Foundation

enum CardState: Int {
    case alpha = 1
    case beta = 2
    case gamma = 3
    
    static let all: [CardState] = [.alpha, .beta, .gamma]
}

extension CardState {
    func allSame(one: CardState, other: CardState) -> Bool {
        return self == one && self == other
    }
    
    func allDifferent(one: CardState, other:CardState) -> Bool {
        return self != one && self != other && one != other
    }
    
    func allSameOrAllDifferent(one: CardState, other: CardState) -> Bool {
        return allSame(one: one, other: other) || allDifferent(one: one, other: other)
    }
}

/// A UI agnostic SetGame Card that has 4 attributes
struct Card: Hashable, Equatable {
    typealias CardNumber = CardState
    typealias CardSymbol = CardState
    typealias CardShading = CardState
    typealias CardColor = CardState
    
    var number: CardNumber
    var symbol: CardSymbol
    var shading: CardShading
    var color: CardColor
    
    func matchesPair(first: Card, second: Card) -> Bool {
        var numbersFollowMatchingRule = false
        var symbolsFollowMatchingRule = false
        var shadingFollowMatchingRule = false
        var colorsFollowMatchingRule = false
        
        /* Numbers are all the same, or are all different */
        if self.number.allSameOrAllDifferent(one: first.number, other: second.number) {
            numbersFollowMatchingRule = true
        }
        
        /* Symbols are all the same, or are all different */
        if self.symbol.allSameOrAllDifferent(one: first.symbol, other: second.symbol) {
            symbolsFollowMatchingRule = true
        }
        
        /* Shading are all the same, or are all different */
        if self.shading.allSameOrAllDifferent(one: first.shading, other: second.shading) {
            shadingFollowMatchingRule = true
        }
        
        /* Colors are all the same, or are all different */
        if self.color.allSameOrAllDifferent(one: first.color, other: second.color) {
            colorsFollowMatchingRule = true
        }
        
        return numbersFollowMatchingRule && symbolsFollowMatchingRule && shadingFollowMatchingRule && colorsFollowMatchingRule
    }
}
