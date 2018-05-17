//
//  ViewController.swift
//  SetGame
//
//  Created by Vishnu Gopal on 17/05/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy private var game = SetGame(initialDealSize: 12, playingDeckMaxSize: cardButtons.count)
    
    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        updateUI()
    }

    @IBAction func dealThreeCards() {
        game.dealThreeCards()
        updateUI()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let selectedIndex = cardButtons.index(of: sender) {
            game.selectCard(byIndex: selectedIndex)
        } else {
            
        }
        updateUI()
    }
    
    private func getAttributedString(forCard card:Card) -> NSAttributedString {
        var symbol: String
        var foregroundColor: UIColor
        var strokeWidth: Int
        var strokeColor: UIColor
        
        
        /* symbol is one of three things based on card.symbol state */
        switch card.symbol {
        case 1:
            symbol = "▲"
        case 2:
            symbol = "●"
        case 3:
            symbol = "■"
        default:
            symbol = ""
        }
        
        /* Repeat symbol number times */
        symbol = String(repeating: symbol, count: card.number)
        
        /* foregroundColor & strokeColor is one of three things based on card.color */
        switch card.color {
        case 1:
            foregroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            strokeColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case 2:
            foregroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            strokeColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case 3:
            foregroundColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
            strokeColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        default:
            foregroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        /* shading is depicted by a combination of foregroundColor, strokeWidth & strokeColor */
        switch card.shading {
        case 1: /* striped */
            foregroundColor = foregroundColor.withAlphaComponent(0.15)
            strokeColor = foregroundColor
            strokeWidth = -2
        case 2: /* filled */
            strokeWidth = -2
        case 3: /* outline */
            strokeWidth = +5
        default:
            strokeWidth = 0
        }
        
        let attributedStringKeys: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: foregroundColor,
            NSAttributedStringKey.strokeWidth: strokeWidth,
            NSAttributedStringKey.strokeColor: strokeColor
        ]
        
        let attributedString = NSAttributedString(string: symbol, attributes: attributedStringKeys)
        
        return attributedString
    }
    
    private func updateUI() {
        /* hide all cards first */
        for cardButton in cardButtons {
            cardButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            cardButton.layer.borderWidth = 0.0
        }
        
        /* now show only those cards that are in play */
        for index in game.cardsInPlay.indices {
            let gameCard = game.cardsInPlay[index]
            cardButtons[index].setAttributedTitle(getAttributedString(forCard: gameCard), for: UIControlState.normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 0.9137254902, green: 1, blue: 0.9176470588, alpha: 1)
        }
        
        /* mark selected */
        for card in game.selectedCards {
            if let index = game.cardsInPlay.index(of: card) {
                cardButtons[index].layer.borderWidth = 3.0
                cardButtons[index].layer.borderColor = game.inMatchedState ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }
    }
}

