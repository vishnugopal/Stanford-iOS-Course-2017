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
        
        var color: UIColor {
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
    var pipNumber: Int = 1
    var symbol: Symbol = .oval
    var shading: Shading = .open
    var color: Color = .red
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        let path = UIBezierPath(roundedRect: pipRect(pipPosition: pipNumber, totalPips: 3), byRoundingCorners: [UIRectCorner.topRight, .topLeft, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        color.color.setStroke()
        path.stroke()
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
    private func pipRect(pipPosition: Int, totalPips: Int) -> CGRect {
        assert(totalPips >= pipPosition, "CardView.pipRect(pipPosition:\(pipPosition), totalPips:\(totalPips)): Total pips must be greater or equal to than pip position.")
        switch (pipPosition, totalPips) {
        case (1, 1), (2, 3):
            return bounds.secondThird.insetBy(dx: 5, dy: 5)
        case (1, 3):
            return bounds.firstThird.insetBy(dx: 5, dy: 5)
        case (1, 2):
            return bounds.leftHalf.insetBy(dx: 5, dy: 5)
        case (3, 3):
            return bounds.lastThird.insetBy(dx: 5, dy: 5)
        case (2, 2):
            return bounds.rightHalf.insetBy(dx: 5, dy: 5)
        default:
            assertionFailure("CardView.pipRect(pipPosition:\(pipPosition), totalPips:\(totalPips)): Can't draw pips in this combination.")
            return CGRect.zero
        }
    }
}

extension CGRect {
    var firstThird: CGRect {
        return CGRect(x: minX, y: minY, width: width/3, height: height)
    }
    var secondThird: CGRect {
        return CGRect(x: minX + width/3, y: minY, width: width/3, height: height)
    }
    var lastThird: CGRect {
        return CGRect(x: maxX - width/3, y: minY, width: width/3, height: height)
    }
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
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
