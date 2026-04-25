//
//  StackViewBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates and configures a UIStackView with the given parameters.
class StackViewFactory: StackViewCreating {
    
    /// Singleton reference.
    static let shared = StackViewFactory()
    
    /// Prevents external initializing.
    private init() {}
    
    /// Creates a vertical UIStackView.
    /// - Parameters:
    ///   - spacer: Space between elements
    ///   - distribution: Space distribution rule
    ///   - alignment: Element alignment rule
    /// - Returns: A configured vertical UIStackView
    func createVerticalStackView(with spacer: CGFloat,
                                 distribution: UIStackView.Distribution,
                                 alignment: UIStackView.Alignment) -> UIStackView {
        return createStackView(with: spacer, axis: .vertical, distribution: distribution, alignment: alignment)
    }
    
    
    /// Creates a horizontal UIStackView.
    /// - Parameters:
    ///   - spacer: Space between elements
    ///   - distribution: Space distribution rule
    ///   - alignment: Element alignment rule
    /// - Returns: A configured horizontal UIStackView
    func createHorizontalStackView(with spacer: CGFloat,
                                   distribution: UIStackView.Distribution,
                                   alignment: UIStackView.Alignment) -> UIStackView {
        return createStackView(with: spacer, axis: .horizontal, distribution: distribution, alignment: alignment)
    }
    
    /// Creates a UIStackView with the specified parameters.
    /// - Parameters:
    ///   - spacer: Space between elements
    ///   - axis: Stack orientation (.vertical or .horizontal)
    ///   - distribution: Space distribution rule
    ///   - alignment: Element alignment rule
    /// - Returns: A configured UIStackView
    private func createStackView(with spacer: CGFloat,
                                 axis: NSLayoutConstraint.Axis,
                                 distribution: UIStackView.Distribution,
                                 alignment: UIStackView.Alignment) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.distribution = distribution
        stack.alignment = alignment
        stack.spacing = spacer
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    
}
