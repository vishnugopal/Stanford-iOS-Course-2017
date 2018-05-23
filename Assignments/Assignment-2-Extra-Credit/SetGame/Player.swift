//
//  Player.swift
//  SetGame
//
//  Created by Vishnu Gopal on 23/05/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import Foundation

protocol PlayerMovable: AnyObject {
    func beforeMove()
    func moveStart()
    func moveEnd()
    func afterMove()
    
}

class Player {
    var moves = 0
    var matches = 0
    var misMatches = 0
    var dealsWhenSetPossibleInCardsInPlay = 0
    var gameStartTime = Date()
    
    private(set) weak var moveDelegate: PlayerMovable!
    private(set) var isAboutToMove = false
    private(set) var isMoving = false
    private var game: SetGame

    var score: Int {
        var score = (matches * 20) - (misMatches * 2) - moves
        let timePassed = Date().timeIntervalSince(gameStartTime)
        if timePassed < Double(5 * matches) {
            score += 10 * matches
        } else if timePassed < Double(10 * matches) {
            score += 5 * matches
        } else if timePassed < Double(20 * matches) {
            score += 2 * matches
        }
        
        //Penalize a deal when a set is possible from the cards in play
        score -= (dealsWhenSetPossibleInCardsInPlay * 5)
        
        return score
    }
    
    func findAndMakeMove() {
        moveDelegate.beforeMove()
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly: 5)!, repeats: false) { _ in
            if !self.game.inMatchedState {
                if let setOfCards = Card.onePossibleSet(fromCards: self.game.cardsInPlay) {
                    self.moveDelegate.moveStart()
                    self.game.clearSelected()
                    for card in setOfCards {
                        if let index = self.game.cardsInPlay.index(of: card) {
                            self.game.selectCard(byIndex: index, forPlayer: self)
                        }
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly: 2)!, repeats: false) { _ in
                        if self.game.canDeal {
                            self.game.dealThreeCards(forPlayer: self)
                        }
                        self.moveDelegate.moveEnd()
                    }
                }
            }
            self.moveDelegate.afterMove()
        }
    }
    
    func reset() {
        moves = 0
        matches = 0
        misMatches = 0
        dealsWhenSetPossibleInCardsInPlay = 0
        gameStartTime = Date()
    }
    
    init(game: SetGame, moveDelegate: PlayerMovable) {
        self.game = game
        self.moveDelegate = moveDelegate
    }
}
