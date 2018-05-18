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
    var matchedCards = [Card]()
    
    private let playingDeckMaxSize: Int
    private let initialDealSize: Int
    
    /* A count of moves, matches and mismatches to calculate score */
    private var moves = 0
    private var matches = 0
    private var misMatches = 0
    
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
            return false
        }
    }
    
    var canDeal: Bool {
        let cannotDeal = /* You cannot deal 3 new cards if: */
            (deck.count == 0 && cardsInPlay.count != 0) /* 1. deck is empty & cardsInPlay is not empty */ ||
                ((cardsInPlay.count == playingDeckMaxSize) && !inMatchedState) /* or: 2. there are enough cards in play, and you are not matched */
        return !cannotDeal
    }
    
    /* Heavily weighed towards matches because game makes it very hard to find a match */
    var score: Int {
        return (matches * 20) - (misMatches * 2) - moves
    }
    
    mutating func selectCard(byIndex index: Int) {
        /* If an index is passed outside cards currently in play, do nothing */
        if index >= cardsInPlay.count {
            return
        }
        
        /* If the card is already matched, do nothing */
        if matchedCards.contains(cardsInPlay[index]) {
            return
        }
        
        /* If the card is already selected, and if number of selected cards < 3, deselect it */
        if selectedCards.count < 3, let selectedIndex = selectedCards.index(of: cardsInPlay[index]) {
            selectedCards.remove(at: selectedIndex)
            return
        }
        
        /* If there's a move, increment moves */
        moves += 1

        /* Automatically deal three cards before proceeding if in matched state */
        if inMatchedState {
            matches += 1
            dealThreeCards()
        } else if (selectedCards.count == 3) {
            misMatches += 1
        }
        
        /* If 3 cards are selected, reset selection */
        if selectedCards.count >= 3 {
            // clear selected cards
            selectedCards = [Card]()
        }
        
        /* Add current card to selected cards */
        if !selectedCards.contains(cardsInPlay[index]) {
            selectedCards.append(cardsInPlay[index])
        }
    }
    
    mutating func dealThreeCards() {
        if inMatchedState {
            for selectedCard in selectedCards {
                matchedCards.append(selectedCard)
                if let index = cardsInPlay.index(of: selectedCard) {
                    if deck.count > 0 {
                        cardsInPlay[index] = removeCardFromDeck()
                    }
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
    
    mutating func reset() {
        deck = [Card]()
        cardsInPlay = [Card]()
        selectedCards = [Card]()
        matchedCards = [Card]()
        populateDeckWithFreshSetGameCards()
        populateInitialPlayingCards()
        resetMoves()
    }
    
    private mutating func resetMoves() {
        moves = 0
        matches = 0
        misMatches = 0
    }
    
    private mutating func removeCardFromDeck() -> Card {
        assert(deck.count > 0, "removeCardFromDeck(): with an empty deck")
        return deck.removeFirst()
    }
    
    private mutating func populateDeckWithFreshSetGameCards() {
        deck = [Card]()
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
    
    init(initialDealSize: Int, playingDeckMaxSize: Int) {
        self.initialDealSize = initialDealSize
        self.playingDeckMaxSize = playingDeckMaxSize
        populateDeckWithFreshSetGameCards()
        populateInitialPlayingCards()
    }
}
