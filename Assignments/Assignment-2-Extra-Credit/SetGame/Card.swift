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
struct Card: Hashable, Equatable, CustomStringConvertible {
    var description: String {
        return "NU:\(number) SY:\(symbol) SH:\(shading) CO: \(color)"
    }
    
    typealias CardNumber = CardState
    typealias CardSymbol = CardState
    typealias CardShading = CardState
    typealias CardColor = CardState
    
    var number: CardNumber
    var symbol: CardSymbol
    var shading: CardShading
    var color: CardColor
    
    static func isSetPossible(fromCards cards: [Card]) -> Bool {
        return findSets(fromCards: cards).count > 0
    }
    
    static func findSets(fromCards cards: [Card]) -> Array<[Card]> {
        var foundSets = Array<[Card]>()
        
        /* Return an empty array if there are not enough cards to check */
        if cards.count < 3 {
            return foundSets
        }
        
        for firstCard in cards[0...(cards.count - 3)] {
            for secondCard in cards[1...(cards.count - 2)] {
                for thirdCard in cards[2...(cards.count - 1)] {
                    if (firstCard == secondCard) || (secondCard == thirdCard) || (firstCard == thirdCard) {
                        break
                    }
                    
                    let cardTriad = [firstCard, secondCard, thirdCard]
                    if isSet(cardTriad) {
                        foundSets.append(cardTriad)
                    }
                }
            }
        }
        
        return foundSets
    }
    
    static func onePossibleSet(fromCards cards: [Card]) -> [Card]? {
        let possibleSets = findSets(fromCards: cards)
        return possibleSets.count > 0 ? possibleSets[0]: nil
    }
    
    static func isSet(_ cards: [Card], simulateMatch: Bool = false) -> Bool {
        if cards.count < 3 {
            return false
        }
        
        if simulateMatch {
            return true
        }
        
        let first = cards[0]
        let second = cards[1]
        let third = cards[2]
        
        var numbersFollowMatchingRule = false
        var symbolsFollowMatchingRule = false
        var shadingFollowMatchingRule = false
        var colorsFollowMatchingRule = false
        
        /* Numbers are all the same, or are all different */
        if third.number.allSameOrAllDifferent(one: first.number, other: second.number) {
            numbersFollowMatchingRule = true
        }
        
        /* Symbols are all the same, or are all different */
        if third.symbol.allSameOrAllDifferent(one: first.symbol, other: second.symbol) {
            symbolsFollowMatchingRule = true
        }
        
        /* Shading are all the same, or are all different */
        if third.shading.allSameOrAllDifferent(one: first.shading, other: second.shading) {
            shadingFollowMatchingRule = true
        }
        
        /* Colors are all the same, or are all different */
        if third.color.allSameOrAllDifferent(one: first.color, other: second.color) {
            colorsFollowMatchingRule = true
        }
        
        return numbersFollowMatchingRule && symbolsFollowMatchingRule && shadingFollowMatchingRule && colorsFollowMatchingRule
    }
    
    static func newShuffledDeck() -> [Card] {
        var deck = [Card]()
        for number in CardState.all {
            for symbol in CardState.all {
                for shading in CardState.all {
                    for color in CardState.all {
                        let card = Card(number: number, symbol: symbol, shading: shading, color: color)
                        deck.append(card)
                    }
                }
            }
        }
        
        var shuffledDeck = [Card]()
        while deck.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(deck.count)))
            shuffledDeck += [deck.remove(at: randomIndex)]
        }
        return shuffledDeck
    }
    
    
}
