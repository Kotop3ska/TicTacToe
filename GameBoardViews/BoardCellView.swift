//
//  BoardCellView.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit
import AppResources

// MARK: - BoardCellView

/// Represents game board cell.
class BoardCellView: UIView {

    // MARK: - Properties
    
    /// State of the cell: empty, X or O
    var state: State = .empty {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: - Constants
    
    /// Indentation of lines from the edges of the cell.
    private let lineInset: CGFloat = 10
    
    /// Thickness of drawing lines.
    private let lineWidth: CGFloat = 8

    // MARK: - Drawing
    
    /// Draws the cell contents in the given context.
    /// - Parameter rect: Bounds of the rendering area
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineWidth(self.lineWidth)
        fillContext(context: context, rect: rect)
    }

    // MARK: - Animation
    
    /// Animates the cell when placing a shape.
    func animatePlacement() {
        self.alpha = 0
        UIView.animate(withDuration: 0.3) { self.alpha = 1.0 }
    }
    
    // MARK: - Private methods
    
    /// Fills the context with graphics depending on the cell state.
    /// - Parameters:
    ///   - context: Graphics context for rendering
    ///   - rect: Bounds of the rendering area
    private func fillContext(context: CGContext, rect: CGRect) {
        switch self.state {
        case .x:
            context.setStrokeColor(UIColor.playerXColor.cgColor)
            context.move(to: CGPoint(x: self.lineInset, y: self.lineInset))
            context.addLine(to: CGPoint(x: rect.width - self.lineInset, y: rect.height - self.lineInset))
            context.move(to: CGPoint(x: rect.width - self.lineInset, y: self.lineInset))
            context.addLine(to: CGPoint(x: self.lineInset, y: rect.height - self.lineInset))
            context.strokePath()
        case .o:
            context.setStrokeColor(UIColor.playerOColor.cgColor)
            let insetRect = rect.insetBy(dx: self.lineInset, dy: self.lineInset)
            context.strokeEllipse(in: insetRect)
        case .empty:
            break
        }
    }
}
