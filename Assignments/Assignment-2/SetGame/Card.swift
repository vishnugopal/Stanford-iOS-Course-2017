//
//  Card.swift
//  SetGame
//
//  Created by Vishnu Gopal on 17/05/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import Foundation


/// A UI agnostic SetGame Card that has 4 attributes
struct Card: Hashable, Equatable {
    typealias CardNumber = Int
    typealias CardSymbol = Int
    typealias CardShading = Int
    typealias CardColor = Int
    
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
        if (self.number == first.number && self.number == second.number) {
            numbersFollowMatchingRule = true
        }
        if (self.number != first.number && first.number != second.number && self.number != second.number) {
            numbersFollowMatchingRule = true
        }
        
        /* Symbols are all the same, or are all different */
        if (self.symbol == first.symbol && self.symbol == second.symbol) {
            symbolsFollowMatchingRule = true
        }
        if (self.symbol != first.symbol && first.symbol != second.symbol && self.symbol != second.symbol) {
            symbolsFollowMatchingRule = true
        }
        
        /* Shading are all the same, or are all different */
        if (self.shading == first.shading && self.shading == second.shading) {
            shadingFollowMatchingRule = true
        }
        if (self.shading != first.shading && first.shading != second.shading && self.shading != second.shading) {
            shadingFollowMatchingRule = true
        }
        
        /* Colors are all the same, or are all different */
        if (self.color == first.color && self.color == second.color) {
            colorsFollowMatchingRule = true
        }
        if (self.color != first.color && first.color != second.color && self.color != second.color) {
            colorsFollowMatchingRule = true
        }
        
        return numbersFollowMatchingRule && symbolsFollowMatchingRule && shadingFollowMatchingRule && colorsFollowMatchingRule
    }
}
