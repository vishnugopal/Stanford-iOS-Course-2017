//
//  Concentration.swift
//  Concentration
//
//  Created by Vishnu Gopal on 30/04/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import Foundation

class Concentration {
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    var previouslyMismatchedCardsIndex = [Int]()
    var score = 0
    var flips = 0
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreMatchedCard()
                } else {
                    scoreCurrentMismatchedCard(withIndex: matchIndex)
                    scoreCurrentMismatchedCard(withIndex: index)
                    addToPreviouslyMismatchedCards(withIndex: matchIndex)
                    addToPreviouslyMismatchedCards(withIndex: index)
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
            flips += 1
        }
    }
    
    func addToPreviouslyMismatchedCards(withIndex index: Int) {
        if !previouslyMismatchedCardsIndex.contains(index) {
            previouslyMismatchedCardsIndex += [index]
        }
    }
    
    func scoreCurrentMismatchedCard(withIndex index: Int) {
        if previouslyMismatchedCardsIndex.contains(index) {
           score -= 1
        }
    }
    
    func scoreMatchedCard() {
        score += 2
    }
    
    func reset(withPairCount numberOfPairsOfCards: Int) {
        //reset Card identifiers so that they start from scratch.
        Card.resetIdentifiers()
        
        //reset cards
        cards = [Card]()
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        //shuffle cards
        shuffleCards()
        
        //reset previously mismatched cards
        previouslyMismatchedCardsIndex = [Int]()
        
        //reset score
        score = 0
        
        //reset flips
        flips = 0
    }
    
    func shuffleCards() {
        var newCards = [Card]()
        while cards.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            newCards += [cards.remove(at: randomIndex)]
        }
        cards = newCards
    }
    
    init(numberOfPairsOfCards: Int) {
        reset(withPairCount: numberOfPairsOfCards)
    }
}
