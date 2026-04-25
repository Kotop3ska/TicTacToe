//
//  TextFieldBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates and configures a UITextField
class TextFieldFactory: TextFieldCreating {
    
    /// Singleton reference.
    static let shared = TextFieldFactory()
    
    /// Prevents external initializing.
    private init() {}
    
    
    /// Creates a UITextField with custom styling.
    /// - Parameters:
    ///   - placeholder: Hint text in an empty field
    ///   - borderColor: Field border color
    ///   - borderWidth: Border thickness
    ///   - cornerRadius: Corner radius
    ///   - backgroundColor: Field background color
    ///   - textColor: Input text color
    /// - Returns: A customized UITextField
    func createTextField(placeholder: String,
                         borderColor: UIColor,
                         borderWidth: CGFloat,
                         cornerRadius: CGFloat,
                         backgroundColor: UIColor,
                         textColor: UIColor) -> UITextField {
        
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = borderWidth
        textField.layer.borderColor = borderColor.cgColor
        textField.layer.cornerRadius = cornerRadius
        textField.clipsToBounds = true
        textField.backgroundColor = backgroundColor
        textField.textColor = textColor
        textField.overrideUserInterfaceStyle = .light
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }
}
