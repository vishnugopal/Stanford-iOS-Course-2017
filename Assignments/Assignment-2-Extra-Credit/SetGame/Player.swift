//
//  Player.swift
//  SetGame
//
//  Created by Vishnu Gopal on 23/05/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import Foundation

class Player {
    var moves = 0
    var matches = 0
    var misMatches = 0
    var dealsWhenSetPossibleInCardsInPlay = 0
    var gameStartTime = Date()

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
    
    func reset() {
        moves = 0
        matches = 0
        misMatches = 0
        dealsWhenSetPossibleInCardsInPlay = 0
        gameStartTime = Date()
    }
}
