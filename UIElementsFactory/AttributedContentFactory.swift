//
//  AttributedContentBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates content for buttons.
class AttributedContentFactory {
    
    /// Singleton reference.
    static let shared = AttributedContentFactory()
    
    /// Prevents external initialization.
    private init() {}
    
    /// Makes attributed attachment with image.
    /// - Parameters:
    ///   - image: Source image
    ///   - scale: Scaling factor
    ///   - offset: Vertical offset along the Y axis
    ///   - tintColor: Image tint color
    /// - Returns:NSMutableAttributedString with nested NSTextAttachment
    func makeAttachment(image: UIImage?,
                  scale: CGFloat,
                  offset: CGFloat,
                  tintColor: UIColor) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString()
        
        if let image = image?.withTintColor(tintColor, renderingMode: .alwaysOriginal) {
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0,
                                       y: offset,
                                       width: image.size.width * scale,
                                       height: image.size.height * scale)
            attributedString.append(NSAttributedString(attachment: attachment))
        }
        
        return attributedString
    }
    
    
    /// Makes attributed attachment with text.
    /// - Parameters:
    ///   - title: Content text
    ///   - color: Text color
    /// - Returns: NSAttributedString text
    func makeAttachment(title: String, color: UIColor = .white) -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [.foregroundColor: color])
    }
    
}
