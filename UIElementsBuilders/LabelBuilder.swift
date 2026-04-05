//
//  LableBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates UILabel.
class LabelBuilder: LableBuilding {
    
    /// Singleton reference.
    static let shared = LabelBuilder()
    
    /// Prevents external initializing.
    private init() {}
    
    /// Creates UILabel.
    /// - Parameters:
    ///   - text: Label text
    ///   - color: Label color
    ///   - fontSize: Font size
    /// - Returns: Configured label
    func createLabel(text: String, color: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = color
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
