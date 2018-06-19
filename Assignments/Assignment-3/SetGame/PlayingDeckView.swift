//
//  PlayingDeckView.swift
//  SetGame
//
//  Created by Vishnu Gopal on 19/06/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import UIKit

class PlayingDeckView: UIView {
    
    lazy var grid: Grid = Grid(layout: .aspectRatio(CGFloat(2.0)), frame: self.bounds)

    var cards = [CardView]() {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    override func draw(_ rect: CGRect) {
        grid = Grid(layout: .aspectRatio(CGFloat(2.0)), frame: self.bounds)
        grid.cellCount = cards.count
        for (index, card) in cards.enumerated() {
            self.addSubview(card)
            if let cardFrame = grid[index] {
                card.frame = cardFrame
            }
        }
    }
}
