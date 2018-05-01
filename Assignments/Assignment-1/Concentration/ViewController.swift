//
//  ViewController.swift
//  Concentration
//
//  Created by Vishnu Gopal on 29/04/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var numberOfPairsOfCardsInGame: Int {
        get {
            return(cardButtons.count + 1) / 2
        }
    }
    
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCardsInGame)
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    var cardTitles = ["🎃", "👻", "🎃", "👻"]
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            if game.chooseCard(at: cardNumber) {
                flipCount += 1
            }
            updateViewFromModel()
        } else {
            print("Card not found in cardTitles")
        }
    }
    
    @IBAction func newGame() {
        game.reset(withPairCount: numberOfPairsOfCardsInGame)
        flipCount = 0
        randomizeEmojiTheme()
        updateViewFromModel()
    }
    
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    func randomizeEmojiTheme() {
        //reset Emoji placeholders for each button
        emoji = [Int: String]()
        
        //randomize emojiChoices by selecting a random theme
        emojiChoices = emojiChoicesWithARandomTheme()
    }
    
    func emojiChoicesWithARandomTheme() -> [String] {
        let themes = Array(emojiThemes.keys)
        let randomIndex = Int(arc4random_uniform(UInt32(themes.count)))
        return emojiThemes[themes[randomIndex]]!
    }
    
    var emojiThemes = ["animals": ["🐼", "🐔", "🦄", "🐧", "🐦", "🐤", "🐣", "🦆", "🦉"],
                       "sports": ["🏀", "🏈", "⚾", "⚽️", "🎾", "🏉", "🎱", "🥊", "⛷"],
                       "faces": ["😀", "😢", "😉", "☺️", "😘", "😝", "😣", "😡", "😨"],
                       "hands": ["🤲", "👏", "👍", "👎", "👊", "👌","💪", "🖕", "🙏"],
                       "food": ["🍏", "🍎", "🍋", "🍉", "🍇", "🍍","🍆", "🥕", "🌽"],
                       "symbols": ["💟", "✝️", "🕉", "✡️", "☯️", "♊️","♎️", "♓️", "⚛️"]
    ]
    
    lazy var emojiChoices = emojiChoicesWithARandomTheme()
    
    var emoji = [Int: String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?"
    }
}

