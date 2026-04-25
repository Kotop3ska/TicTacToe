//
//  ButtonBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates UIButton with attributed content.
class ButtonFactory: ButtonCreating {
    
    /// Singleton reference.
    public static let shared = ButtonFactory()
    
    /// delegates the creation of attributed content.
    private let contentBuilder = AttributedContentFactory.shared
    
    /// Prevents external initializing.
    private init() {}
    
    // MARK: - Public interface
    
    /// Creates button with attributed content.
    /// - Parameters:
    ///   - attachment: Attributed string with image or text
    ///   - color: Button color
    ///   - cornerRadius:Corner rounding radius
    ///   - fontSize: Font size
    /// - Returns: Configurated button
    func createButton(withAttacment attachment: NSMutableAttributedString,
                      color: UIColor,
                      cornerRadius: CGFloat,
                      fontSize: CGFloat) -> UIButton {
        
        let button = configureSystemButton(color: color, cornerRadius: cornerRadius, fontSize: fontSize)
        button.setAttributedTitle(attachment, for: .normal)
        
        return button
    }
    
    /// Creates button with icon from SF Symbols.
    /// - Parameters:
    ///   - iconName: Icon name in SF Symbols
    ///   - color: button color
    ///   - cornerRadius:Corner rounding radius
    ///   - fontSize: Font size
    /// - Returns: Configurated button
    func createButton(withIcon iconName: String,
                      color: UIColor,
                      cornerRadius: CGFloat,
                      fontSize: CGFloat) -> UIButton {
        
        let attachment = makeAttachment(image: UIImage(systemName: iconName))
        let button = configureSystemButton(color: color, cornerRadius: cornerRadius, fontSize: fontSize)
        button.setAttributedTitle(attachment, for: .normal)
        
        return button
    }
    
    /// Makes attributed attachment with image.
    /// - Parameters:
    ///   - image: Source image
    ///   - scale: Scaling factor
    ///   - offset: Vertical offset along the Y axis
    ///   - tintColor: Image tint color
    /// - Returns:NSMutableAttributedString with nested NSTextAttachment
    func makeAttachment(image: UIImage?,
                        scale: CGFloat = 1.7,
                        offset: CGFloat = -4,
                        tintColor: UIColor = .white) -> NSMutableAttributedString {
        
        return self.contentBuilder.makeAttachment(image: image, scale: scale, offset: offset, tintColor: tintColor)
    }
    
    /// Makes attributed attachment with text.
    /// - Parameters:
    ///   - title: Content text
    /// - Returns: NSAttributedString text
    func makeAttachment(title: String) -> NSAttributedString {
        return self.contentBuilder.makeAttachment(title: title)
    }
    
    // MARK: - Private methods
    
    /// Configures the basic settings of the system button.
    /// - Parameters:
    ///   - color: Button color
    ///   - cornerRadius: Corner rounding radius
    ///   - fontSize: Font size
    /// - Returns: Configurated button
    private func configureSystemButton(color: UIColor,
                                       cornerRadius: CGFloat,
                                       fontSize: CGFloat) -> UIButton {
        
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceLeftToRight
        button.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        
        return button
    }
    
}
