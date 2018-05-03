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
    
    lazy var themeChoices = loadThemes()
    lazy var currentTheme = randomizeTheme()
    lazy var currentEmojiChoices = currentTheme.emojiChoices
    var currentEmojiMapping = [Int: String]()
    
    override func viewDidLoad() {
        setThemeColors()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Card not found in cardTitles")
        }
    }
    
    @IBAction func newGame() {
        game.reset(withPairCount: numberOfPairsOfCardsInGame)
        
        //reset Emoji mapping for each button
        currentEmojiMapping = [Int: String]()
        
        let _ = randomizeTheme()
        setThemeColors()
        updateViewFromModel()
    }
    
    func setThemeColors() {
        self.view.backgroundColor = currentTheme.backgroundColor
        for card in cardButtons {
            card.backgroundColor = currentTheme.cardBackColor
        }
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : currentTheme.cardBackColor
            }
        }
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flips)"
    }
    
    func randomizeTheme() -> Theme {
        let randomIndex = Int(arc4random_uniform(UInt32(themeChoices.count)))
        
        //FIXME: Ugly hack because we still don't know how to do proper property initialization
        currentTheme = themeChoices[randomIndex]
        currentEmojiChoices = currentTheme.emojiChoices
        
        return themeChoices[randomIndex]
    }
    
    func loadThemes() -> [Theme] {
        var themes = [Theme]()
        var theme = Theme(name: "animals",
                          emojiChoices: ["🐼", "🐔", "🦄", "🐧", "🐦", "🐤", "🐣", "🦆", "🦉"],
                          backgroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
                          cardBackColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
        themes.append(theme)
        theme = Theme(name: "sports", emojiChoices: ["🏀", "🏈", "⚾", "⚽️", "🎾", "🏉", "🎱", "🥊", "⛷"],
                      backgroundColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
                      cardBackColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        themes.append(theme)
        theme = Theme(name: "faces",
                      emojiChoices: ["😀", "😢", "😉", "☺️", "😘", "😝", "😣", "😡", "😨"],
                      backgroundColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),
                      cardBackColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        themes.append(theme)
        theme = Theme(name: "hands",
                      emojiChoices: ["🤲", "👏", "👍", "👎", "👊", "👌","💪", "🖕", "🙏"],
                      backgroundColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),
                      cardBackColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        themes.append(theme)
        theme = Theme(name: "food",
                      emojiChoices: ["🍏", "🍎", "🍋", "🍉", "🍇", "🍍","🍆", "🥕", "🌽"],
                      backgroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
                      cardBackColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        themes.append(theme)
        theme = Theme(name: "symbols",
                      emojiChoices: ["💟", "✝️", "🕉", "✡️", "☯️", "♊️","♎️", "♓️", "⚛️"],
                      backgroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                      cardBackColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        themes.append(theme)
        
        return themes
    }
    
    func emoji(for card: Card) -> String {
        if currentEmojiMapping[card.identifier] == nil, currentEmojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(currentEmojiChoices.count)))
            currentEmojiMapping[card.identifier] = currentEmojiChoices.remove(at: randomIndex)
        }
        
        return currentEmojiMapping[card.identifier] ?? "?"
    }
}

