//
//  ViewController.swift
//  SetGame
//
//  Created by Vishnu Gopal on 17/05/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PlayerMovable {
    //MARK: Model
    
    private var humanPlayer: Player! = nil
    private var computerPlayer: Player! = nil
    private var isComputerMoving = false
    private var isComputerAboutToMove = false
    private var game: SetGame! = nil
    
    lazy private var computerTimer: Timer = timerForComputerPlayer()
    
    //MARK: Outlets
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var computerScoreLabel: UILabel!
    
    //MARK: Actions
    @IBAction func newGame() {
        computerTimer.invalidate()
        computerTimer = timerForComputerPlayer()
        game.reset()
        updateUI()
    }
    
    @IBAction func dealThreeCards() {
        if isComputerMoving {
            return
        }
        
        game.dealThreeCards(forPlayer: humanPlayer)
        updateUI()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if isComputerMoving {
            return
        }
        
        if let selectedIndex = cardButtons.index(of: sender) {
            game.selectCard(byIndex: selectedIndex, forPlayer: humanPlayer)
        } else {
            assertionFailure("touchCard(\(sender)): Can't find touched card in the cards visible.")
        }
        updateUI()
    }

    @IBAction func provideHint() {
        if let setOfCards = Card.onePossibleSet(fromCards: game.cardsInPlay) {
            for card in setOfCards {
                if let index = game.cardsInPlay.index(of: card) {
                    cardButtons[index].layer.borderWidth = 3.0
                    cardButtons[index].layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
            }
        } else {
            let alert = UIAlertController(title: "No matches!", message: "No matches found, try dealing more cards?.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Deal Cards", comment: "Default action"), style: .`default`, handler: { _ in
                self.dealThreeCards()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Overrides
    
    override func viewDidLoad() {
        game = SetGame(initialDealSize: 20, playingDeckMaxSize: cardButtons.count)
        humanPlayer = Player(game: game, moveDelegate: self)
        computerPlayer = Player(game: game, moveDelegate: self)
        game.players = [humanPlayer, computerPlayer]
        
        computerTimer.tolerance = 2
        updateUI()
    }
    
    //MARK: Delegate Functions
    
    func beforeMove() {
        self.isComputerAboutToMove = true
        self.updateUI()
    }
    
    func moveStart() {
        self.isComputerMoving = true
    }
    
    func moveEnd() {
        self.isComputerMoving = false
        self.updateUI()
    }
    
    func afterMove() {
        self.isComputerAboutToMove = false
        self.updateUI()
    }
    
    //MARK: Private Functions

    private func getAttributedString(forCard card:Card) -> NSAttributedString {
        var symbol: String
        var foregroundColor: UIColor
        var strokeWidth: Int
        var strokeColor: UIColor
        
        
        /* symbol is one of three things based on card.symbol state */
        switch card.symbol {
        case .alpha:
            symbol = "▲"
        case .beta:
            symbol = "●"
        case .gamma:
            symbol = "■"
        }
        
        /* Repeat symbol number times */
        symbol = String(repeating: symbol, count: card.number.rawValue)
        
        /* foregroundColor & strokeColor is one of three things based on card.color */
        switch card.color {
        case .alpha:
            foregroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            strokeColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .beta:
            foregroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            strokeColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .gamma:
            foregroundColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
            strokeColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        }
        
        /* shading is depicted by a combination of foregroundColor, strokeWidth & strokeColor */
        switch card.shading {
        case .alpha: /* striped */
            foregroundColor = foregroundColor.withAlphaComponent(0.15)
            strokeColor = foregroundColor
            strokeWidth = -2
        case .beta: /* filled */
            strokeWidth = -2
        case .gamma: /* outline */
            strokeWidth = +5
        }
        
        let attributedStringKeys: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: foregroundColor,
            NSAttributedStringKey.strokeWidth: strokeWidth,
            NSAttributedStringKey.strokeColor: strokeColor
        ]
        
        let attributedString = NSAttributedString(string: symbol, attributes: attributedStringKeys)
        
        return attributedString
    }
    
    private func timerForComputerPlayer() -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly: 15)!, repeats: true) { _ in
            self.computerPlayer.findAndMakeMove()
        }
        
        return timer
    }
    
    private func updateUI() {
        /* let's reset all state first */
        dealButton.isEnabled = true
        playerScoreLabel.text = "Player: 0"
        for cardButton in cardButtons {
            cardButton.setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
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
        
        /* hide already matched */
        for card in game.matchedCards {
            if let index = game.cardsInPlay.index(of: card) {
                cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
                cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
                cardButtons[index].layer.borderWidth = 0.0
            }
        }
        
        /* disable deal card button */
        if !game.canDeal || isComputerMoving {
            dealButton.isEnabled = false
        }
        
        /* Correct score */
        if isComputerMoving {
            playerScoreLabel.text = "😞Player: \(humanPlayer.score)"
            computerScoreLabel.text = "😀Score:\(computerPlayer.score)"
        } else if isComputerAboutToMove {
            playerScoreLabel.text = "😨Player: \(humanPlayer.score)"
            computerScoreLabel.text = "😎Score:\(self.computerPlayer.score)"
        } else {
            playerScoreLabel.text = "🤔Player: \(humanPlayer.score)"
            computerScoreLabel.text = "🤔Score:\(computerPlayer.score)"
        }
    }
}

