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
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
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
        }
    }
    
    func resetCards(withPairCount numberOfPairsOfCards: Int) {
        Card.resetIdentifiers()
        cards = [Card]()
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        shuffleCards()
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
        resetCards(withPairCount: numberOfPairsOfCards)
    }
}
