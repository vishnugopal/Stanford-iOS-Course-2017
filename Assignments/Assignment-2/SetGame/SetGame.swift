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
        //uncomment for easier testing
        //return Card.isSet(selectedCards, simulateMatch: true)
        return Card.isSet(selectedCards)
    }
    
    var canDeal: Bool {
        let cannotDeal = /* You cannot deal 3 new cards if: */
            (deck.count == 0) /* 1. deck is empty */
                || ((cardsInPlay.count == playingDeckMaxSize) && !inMatchedState) /* or: 2. the play deck is full, and you are not matched */
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
        
        /* Increment moves */
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
            cardsInPlay = cardsInPlay.map { if selectedCards.contains($0) {
                    return deck.count > 0 ? removeCardFromDeck(): $0
                } else {
                    return $0
                }
            }
            
            // clear selected cards
            selectedCards = [Card]()
        } else {
            /* Remove number cards from deck where number is: 1. is less than the playingDeckMaxSize, and 2. less than the deck size */
            var cardsToRemove = (playingDeckMaxSize - cardsInPlay.count) > 3 ? 3: (playingDeckMaxSize - cardsInPlay.count)
            cardsToRemove = cardsToRemove > deck.count ? deck.count: cardsToRemove
            
            for _ in 0..<cardsToRemove {
                cardsInPlay += [removeCardFromDeck()]
            }
        }
        assert(cardsInPlay.count <= playingDeckMaxSize, "dealThreeCards(): more cards in play than max playing deck size")
    }
    
    mutating func reset() {
        deck = Card.newShuffledDeck()
        populateInitialPlayingCards()
        
        selectedCards = [Card]()
        matchedCards = [Card]()
        
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
    
    private mutating func populateInitialPlayingCards() {
        cardsInPlay = [Card]()
        repeat {
            dealThreeCards()
        } while cardsInPlay.count < initialDealSize
    }
    
    init(initialDealSize: Int, playingDeckMaxSize: Int) {
        self.initialDealSize = initialDealSize
        self.playingDeckMaxSize = playingDeckMaxSize
        reset()
    }
}
