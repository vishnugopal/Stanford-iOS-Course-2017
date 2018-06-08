//
//  CardView.swift
//  SetGame
//
//  Created by Vishnu Gopal on 07/06/18.
//  Copyright © 2018 Vishworks. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    enum Symbol {
        case diamond
        case squiggle
        case oval
    }
    
    enum Shading {
        case solid
        case striped
        case open
    }
    
    enum Color {
        case red
        case green
        case purple
        
        var drawColor: UIColor {
            get {
                switch self {
                case .red:
                    return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                case .green:
                    return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                case .purple:
                    return #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
                }
            }
        }
    }
    
    @IBInspectable
    var pipNumber: Int = 3
    var symbol: Symbol = .oval
    var shading: Shading = .striped
    var color: Color = .red
    
    override func draw(_ rect: CGRect) {
        drawCardOutline()
        drawPips()
    }
    
    /** Draw the rounded outline of a card */
    private func drawCardOutline() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    /** Draw all the pips */
    private func drawPips() {
        for position in 1...pipNumber {
            drawPip(atPosition: position, withTotalPips: pipNumber)
        }
    }
    
    /**
        Draw a pip at position.
     
        Will correctly align the pip based on the total number of pips in the card.
     */
    private func drawPip(atPosition pipPosition: Int, withTotalPips totalPips: Int) {
        let enclosingRect = pipRect(atPosition: pipPosition, withTotalPips: totalPips)
        switch symbol {
        case .oval:
            drawOvalPip(withinRect: enclosingRect)
        default:
            return
        }
    }
    
    private func drawOvalPip(withinRect enclosingRect: CGRect) {
        let path = UIBezierPath(roundedRect: enclosingRect, byRoundingCorners: [UIRectCorner.topRight, .topLeft, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        color.drawColor.setStroke()
        path.stroke()
        switch shading {
        case .open:
            break
        case .solid:
            color.drawColor.setFill()
            path.fill()
        case .striped:
            let imageRenderer = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4))
            
            let stripes = imageRenderer.image { context in
                let imageContext = context.cgContext
                imageContext.setFillColor(color.drawColor.cgColor)
                imageContext.fill(CGRect(x: 0, y: 0, width: 4, height: 2))
                imageContext.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor)
                imageContext.fill(CGRect(x: 2, y: 0, width: 4, height: 2))
            }
            
            let stripesPattern = UIColor(patternImage: stripes)
            stripesPattern.setFill()
            path.fill()
        }
    }
    
    /** Get the rectangle to draw the pip */
    private func pipRect(atPosition pipPosition: Int, withTotalPips totalPips: Int) -> CGRect {
        assert(totalPips >= pipPosition, "CardView.pipRect(pipPosition:\(pipPosition), totalPips:\(totalPips)): Total pips must be greater or equal to than pip position.")
        switch (pipPosition, totalPips) {
        /* Just one pip */
        case (1, 1):
            return bounds.secondThird.inset(by: CGRect.standardSpacing)
        /* Two pips */
        case (1, 2):
            return bounds.leftMiddleThird.inset(by: CGRect.standardSpacing)
        case (2, 2):
            return bounds.rightMiddleThird.inset(by: CGRect.standardSpacing)
        /* Three pips */
        case (1, 3):
            return bounds.firstThird.inset(by: CGRect.standardSpacing)
        case (2, 3):
            return bounds.secondThird.inset(by: CGRect.standardSpacing)
        case (3, 3):
            return bounds.lastThird.inset(by: CGRect.standardSpacing)
        default:
            assertionFailure("CardView.pipRect(pipPosition:\(pipPosition), totalPips:\(totalPips)): Can't draw pips in this combination.")
            return CGRect.zero
        }
    }
}

extension CardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let pipSizeToBoundsSize: CGFloat = 0.15
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
}

extension CGRect {
    static var standardSpacing: CGSize {
        return CGSize(width: 16, height: 16)
    }
    var firstThird: CGRect {
        return CGRect(x: minX, y: minY, width: width/3, height: height)
    }
    var secondThird: CGRect {
        return CGRect(x: minX + width/3, y: minY, width: width/3, height: height)
    }
    var lastThird: CGRect {
        return CGRect(x: maxX - width/3, y: minY, width: width/3, height: height)
    }
    var leftMiddleThird: CGRect {
        return CGRect(x: midX - width/3, y: minY, width: width/3, height: height)
    }
    var rightMiddleThird: CGRect {
        return CGRect(x: midX, y: minY, width: width/3, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
