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
    var players = [Player]()
    
    private let playingDeckMaxSize: Int
    private let initialDealSize: Int
    
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
    
    mutating func selectCard(byIndex index: Int, forPlayer player: Player) {
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
        player.moves += 1

        /* Automatically deal three cards before proceeding if in matched state */
        if inMatchedState {
            player.matches += 1
            dealThreeCards(forPlayer: player)
        } else if (selectedCards.count == 3) {
            player.misMatches += 1
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
        
        /* Set last played player */
        
    }
    
    mutating func dealThreeCards(forPlayer player: Player) {
        if inMatchedState {
            //increase matches count
            player.matches += 1
            
            //return a new card from deck if there are cards in pla
            cardsInPlay = cardsInPlay.map { if selectedCards.contains($0) {
                    return deck.count > 0 ? removeCardFromDeck(): $0
                } else {
                    return $0
                }
            }
            
            // clear selected cards
            selectedCards = [Card]()
        } else {
            if Card.isSetPossible(fromCards: cardsInPlay) {
                player.dealsWhenSetPossibleInCardsInPlay += 1
            }
            
            /* Remove number cards from deck where number is: 1. is less than the playingDeckMaxSize, and 2. less than the deck size */
            var cardsToRemove = (playingDeckMaxSize - cardsInPlay.count) > 3 ? 3: (playingDeckMaxSize - cardsInPlay.count)
            cardsToRemove = cardsToRemove > deck.count ? deck.count: cardsToRemove
            
            for _ in 0..<cardsToRemove {
                cardsInPlay += [removeCardFromDeck()]
            }
        }
        assert(cardsInPlay.count <= playingDeckMaxSize, "dealThreeCards(): more cards in play than max playing deck size")
    }
    
    mutating func clearSelected() {
        selectedCards = [Card]()
    }
    
    mutating func reset() {
        deck = Card.newShuffledDeck()
        populateInitialPlayingCards()
        
        selectedCards = [Card]()
        matchedCards = [Card]()
        
        resetPlayers()
    }
    
    private mutating func resetPlayers() {
        for player in players {
            player.reset()
        }
    }
    
    private mutating func removeCardFromDeck() -> Card {
        assert(deck.count > 0, "removeCardFromDeck(): with an empty deck")
        return deck.removeFirst()
    }
    
    private mutating func populateInitialPlayingCards() {
        cardsInPlay = [Card]()
        
        for _ in 0..<initialDealSize {
            cardsInPlay += [removeCardFromDeck()]
        }
    }
    
    init(initialDealSize: Int, playingDeckMaxSize: Int, players: [Player]) {
        assert(playingDeckMaxSize > initialDealSize, "SetGame(initialDealSize: \(initialDealSize), playingDeckMaxSize: \(playingDeckMaxSize), players: \(players)): playingDeckMazSize must be greater than the initialDealSize.")
        assert(playingDeckMaxSize % 3 == 0, "SetGame(initialDealSize: \(initialDealSize), playingDeckMaxSize: \(playingDeckMaxSize), players: \(players)): playingDeckMaxSize must be a multiple of the regular deal size (3)")
        assert(players.count > 0, "SetGame(initialDealSize: \(initialDealSize), playingDeckMaxSize: \(playingDeckMaxSize), players: \(players)): must have at least one player")

        self.initialDealSize = initialDealSize
        self.playingDeckMaxSize = playingDeckMaxSize
        self.players = players
        
        reset()
    }
}
