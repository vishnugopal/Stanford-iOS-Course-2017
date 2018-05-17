//
//  SetGame.swift
//  SetGame
//
//  Created by Vishnu Gopal on 17/05/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import Foundation

struct SetGame {
    var deck = [Card]()
    var cardsInPlay = [Card]()
    var selectedCards = [Card]()
    
    private let playingDeckMaxSize: Int
    private let initialDealSize: Int
    
    var inMatchedState: Bool {
        if (selectedCards.count < 3) {
            return false
        }
        let card1 = selectedCards[0];
        let card2 = selectedCards[1];
        let card3 = selectedCards[2];
        if card1.matchesPair(first: card2, second: card3) {
            return true
        } else {
            return false;
        }
    }
    
    mutating func selectCard(byIndex index: Int) {
        if index >= cardsInPlay.count {
            return
        }
        
        if inMatchedState {
            dealThreeCards()
        }
        
        if selectedCards.count >= 3 {
            // clear selected cards
            selectedCards = [Card]()
        }
        
        if !selectedCards.contains(cardsInPlay[index]) {
            selectedCards.append(cardsInPlay[index])
        }
    }
    
    mutating func dealThreeCards() {
        if inMatchedState {
            for selectedCard in selectedCards {
                if let index = cardsInPlay.index(of: selectedCard) {
                    cardsInPlay[index] = removeCardFromDeck()
                }
            }
            
            // clear selected cards
            selectedCards = [Card]()
        } else {
            var cardsToRemove = (playingDeckMaxSize - cardsInPlay.count) > 3 ? 3: (playingDeckMaxSize - cardsInPlay.count)
            cardsToRemove = cardsToRemove > deck.count ? deck.count: cardsToRemove
            
            for _ in 0..<cardsToRemove {
                cardsInPlay += [removeCardFromDeck()]
            }
        }
        assert(cardsInPlay.count <= playingDeckMaxSize, "dealThreeCards(): more cards in play than max playing deck size")
    }
    
    private mutating func removeCardFromDeck() -> Card {
        assert(deck.count > 0, "removeCardFromDeck(): with an empty deck")
        return deck.removeFirst()
    }
    
    private mutating func populateDeckWithFreshSetGameCards() {
        deck = [Card]()
        for number in 1...3 {
            for symbol in 1...3 {
                for shading in 1...3 {
                    for color in 1...3 {
                        let card = Card(number: number, symbol: symbol, shading: shading, color: color)
                        deck.append(card)
                    }
                }
            }
        }
        shuffleDeck()
    }
    
    private mutating func shuffleDeck() {
        var newDeck = [Card]()
        while deck.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(deck.count)))
            newDeck += [deck.remove(at: randomIndex)]
        }
        deck = newDeck
    }
    
    private mutating func populateInitialPlayingCards() {
        repeat {
            dealThreeCards()
        } while cardsInPlay.count < initialDealSize
    }
    
    mutating func reset() {
        deck = [Card]()
        cardsInPlay = [Card]()
        selectedCards = [Card]()
        populateDeckWithFreshSetGameCards()
        populateInitialPlayingCards()
    }
    
    init(initialDealSize: Int, playingDeckMaxSize: Int) {
        self.initialDealSize = initialDealSize
        self.playingDeckMaxSize = playingDeckMaxSize
        populateDeckWithFreshSetGameCards()
        populateInitialPlayingCards()
    }
}
