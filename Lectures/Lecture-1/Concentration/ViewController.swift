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
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    var cardTitles = ["🎃", "👻", "🎃", "👻"]
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            flipCount += 1
            flipCard(withEmoji: cardTitles[cardNumber], on: sender)
        } else {
            print("Card not found in cardTitles")
        }
    }
    
    func flipCard(withEmoji emoji: String, on card: UIButton) {
        if (card.currentTitle == emoji) {
            card.setTitle("", for: UIControlState.normal)
            card.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        } else {
            card.setTitle(emoji, for: UIControlState.normal)
            card.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

