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
    var symbol: Symbol = .squiggle
    var shading: Shading = .open
    var color: Color = .green
    
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
        case .diamond:
            drawDiamondPip(withinRect: enclosingRect)
        case .squiggle:
            drawSquigglePip(withinRect: enclosingRect)
        }
    }
    
    private var stripesPattern: UIColor {
        let imageRenderer = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4))
        
        let stripes = imageRenderer.image { context in
            let imageContext = context.cgContext
            imageContext.setFillColor(color.drawColor.cgColor)
            imageContext.fill(CGRect(x: 0, y: 0, width: 4, height: 2))
            imageContext.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor)
            imageContext.fill(CGRect(x: 2, y: 0, width: 4, height: 2))
        }
        
        return UIColor(patternImage: stripes)
    }
    
    private func drawSquigglePip(withinRect enclosingRect: CGRect) {
        let drawArea = enclosingRect.origin
        let drawAreaHeight = enclosingRect.height
        let drawAreaWidth = enclosingRect.width
        
        let ellipse1RectOrigin = drawArea.offsetBy(dx: 0, dy: drawAreaHeight * 0.15)
        let ellipse1RectSize = CGSize(width: drawAreaWidth * 0.3, height: drawAreaHeight * 0.5)
        
        let ellipse2OffsetX = drawAreaWidth - drawAreaWidth * 0.3
        let ellipse2OffsetY = drawAreaHeight - (drawAreaHeight * 0.5 + drawAreaHeight * 0.15)
        
        let ellipse2RectOrigin = ellipse1RectOrigin.offsetBy(dx: ellipse2OffsetX, dy: ellipse2OffsetY)
        let ellipse2RectSize = ellipse1RectSize
        
        let ellipse3RectOrigin = drawArea.offsetBy(dx: drawAreaWidth * 0.15, dy: 0)
        let ellipse3RectSize = CGSize(width: drawAreaWidth * 0.6, height: drawAreaHeight * 0.6)
        
        let ellipse4OffsetX = 2 * drawAreaWidth * 0.15
        let ellipse4OffsetY = drawAreaHeight - (drawAreaHeight * 0.6)
        let ellipse4RectOrigin = drawArea.offsetBy(dx: ellipse4OffsetX, dy: ellipse4OffsetY)
        let ellipse4RectSize = ellipse3RectSize
        
        let ellipse1 = UIBezierPath(ovalIn: CGRect(origin: ellipse1RectOrigin, size: ellipse1RectSize))
        let ellipse2 = UIBezierPath(ovalIn: CGRect(origin: ellipse2RectOrigin, size: ellipse2RectSize))
        let ellipse3 = UIBezierPath(ovalIn: CGRect(origin: ellipse3RectOrigin, size: ellipse3RectSize))
        let ellipse4 = UIBezierPath(ovalIn: CGRect(origin: ellipse4RectOrigin, size: ellipse4RectSize))
        
        color.drawColor.setStroke()
        ellipse3.stroke()
        ellipse4.stroke()
        drawShading(forPath: ellipse3)
        drawShading(forPath: ellipse4)
        
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            context.saveGState()
            ellipse4.addClip()
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setStroke()
            ellipse3.stroke()
            color.drawColor.setStroke()
            ellipse2.stroke()
            context.restoreGState()
            ellipse3.addClip()
            color.drawColor.setStroke()
            ellipse1.stroke()
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setStroke()
            ellipse4.stroke()
            context.restoreGState()
        }
        
        ellipse1.fill()
        ellipse2.fill()

    }
    
    private func drawDiamondPip(withinRect enclosingRect: CGRect) {
        let path = UIBezierPath()
        
        let origin = enclosingRect.origin
        let firstPoint = origin.offsetBy(dx: enclosingRect.width / 2, dy: 0)
        let secondPoint = origin.offsetBy(dx: 0, dy: enclosingRect.height / 2)
        let thirdPoint = firstPoint.offsetBy(dx: 0, dy: enclosingRect.height)
        let fourthPoint = secondPoint.offsetBy(dx: enclosingRect.width, dy: 0)
        
        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        path.addLine(to: fourthPoint)
        path.close()
        color.drawColor.setStroke()
        path.stroke()
        drawShading(forPath: path)
    }
    
    private func drawOvalPip(withinRect enclosingRect: CGRect) {
        let path = UIBezierPath(roundedRect: enclosingRect, byRoundingCorners: [UIRectCorner.topRight, .topLeft, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        color.drawColor.setStroke()
        path.stroke()
        drawShading(forPath: path)
    }
    
    private func drawShading(forPath path: UIBezierPath) {
        switch shading {
        case .open:
            break
        case .solid:
            color.drawColor.setFill()
            path.fill()
        case .striped:
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
    static var standardSpacing: CGPoint {
        return CGPoint(x: 16, y: 16)
    }
    func offsetBy(point: CGPoint) -> CGPoint {
        return CGPoint(x: x+point.x, y:y+point.y)
    }
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
