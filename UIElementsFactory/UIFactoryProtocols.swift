//
//  UIBuildersProtocols.swift
//  TicTacToe
//
//  Created by Dmitry on 4/1/26.
//

import UIKit

// MARK: - Button

/// Defines an interface for creating buttons and attributed content.
public protocol ButtonCreating {
    
    /// Creates a button with predefined attributed content.
    /// - Parameters:
    ///   - attachment: Attributed string for the title
    ///   - color: Button background color
    ///   - cornerRadius: Corner radius
    ///   - fontSize: Font size
    /// - Returns: The configured UIButton
    func createButton(withAttacment attachment: NSMutableAttributedString,
                      color: UIColor,
                      cornerRadius: CGFloat,
                      fontSize: CGFloat) -> UIButton
    
    /// Creates a button with an SF Symbols icon.
    /// - Parameters:
    ///   - iconName: The name of the icon in the SF Symbols system
    ///   - color: The background color of the button
    ///   - cornerRadius: The corner radius
    ///   - fontSize: The font size
    /// - Returns: The configured UIButton with the icon
    func createButton(withIcon iconName: String,
                      color: UIColor,
                      cornerRadius: CGFloat,
                      fontSize: CGFloat) -> UIButton
    
    /// Creates an attributed string with an image.
    /// - Parameters:
    ///   - image: Original image
    ///   - scale: Scaling factor
    ///   - offset: Vertical offset
    ///   - tintColor: Tint color
    /// - Returns: NSMutableAttributedString with the embedded image
    func makeAttachment(image: UIImage?,
                        scale: CGFloat,
                        offset: CGFloat,
                        tintColor: UIColor) -> NSMutableAttributedString
    
    /// Creates an attributed string with text.
    /// - Parameter title: Title text
    /// - Returns: NSAttributedString with default color
    func makeAttachment(title: String) -> NSAttributedString
}

// MARK: - ImageView

/// Defines an interface for creating UIImageView.
public protocol ImageViewCreating {
    
    /// Creates a UIImageView with an image by name.
    /// - Parameter name: Image name in the project resources
    /// - Returns: The configured UIImageView
    func createImageView(name: String) -> UIImageView
}

// MARK: - Lable

/// Defines an interface for creating UILabel.
public protocol LableCreating {
    
    /// Creates a UILabel with the specified text and style.
    /// - Parameters:
    ///   - text: Label content
    ///   - color: Text color
    ///   - fontSize: Font size
    /// - Returns: The configured UILabel
    func createLabel(text: String, color: UIColor, fontSize: CGFloat) -> UILabel
}

// MARK: - PickerView

/// Defines an interface for creating UIPickerView.
public protocol PickerViewCreating {
    
    /// Creates a basic UIPickerView.
    /// - Returns: The configured UIPickerView
    func createPicker() -> UIPickerView
}

// MARK: - ScrollView

/// Defines an interface for creating UIScrollView.
public protocol ScrollViewCreating {
    
    /// Creates a basic UIScrollView.
    /// - Returns: The configured UIScrollView
    func createScrollView() -> UIScrollView
}

// MARK: - SegmentedControl

/// Defines an interface for creating UISegmentedControl.
public protocol SegmentedControlCreating {
    
    /// Creates a UISegmentedControl with the specified parameters.
    /// - Parameters:
    ///   - items: Array of segment titles
    ///   - selectedIndex: Index of the selected segment
    ///   - selectedTintColor: Background color of the selected segment
    ///   - backgroundColor: Control background color
    ///   - selectedTextColor: Text color of the selected segment
    ///   - normalTextColor: Text color of inactive segments
    /// - Returns: The configured UISegmentedControl
    func createSegmentedControl(items: [String],
                                selectedIndex: Int,
                                selectedTintColor: UIColor,
                                backgroundColor: UIColor?,
                                selectedTextColor: UIColor,
                                normalTextColor: UIColor) -> UISegmentedControl
}

// MARK: - StackView

/// Defines an interface for creating UIStackView.
public protocol StackViewCreating {
    
    /// Creates a vertical UIStackView.
    /// - Parameters:
    ///   - spacer: Space between elements
    ///   - distribution: Space distribution rule
    ///   - alignment: Element alignment rule
    /// - Returns: The configured vertical UIStackView
    func createVerticalStackView(with spacer: CGFloat,
                                 distribution: UIStackView.Distribution,
                                 alignment: UIStackView.Alignment) -> UIStackView
    
    /// Creates a horizontal UIStackView.
    /// - Parameters:
    ///   - spacer: Space between elements
    ///   - distribution: Space distribution rule
    ///   - alignment: Element alignment rule
    /// - Returns: The configured horizontal UIStackView
    func createHorizontalStackView(with spacer: CGFloat,
                                   distribution: UIStackView.Distribution,
                                   alignment: UIStackView.Alignment) -> UIStackView
    
}

// MARK: - Switch

/// Defines an interface for creating UISwitch.
public protocol SwitchCreating {
    
    /// Creates a basic UISwitch.
    /// - Returns: The configured UISwitch
    func createSwitch() -> UISwitch
}

// MARK: - TextField

/// Defines an interface for creating UITextField.
public protocol TextFieldCreating {
    
    // Creates a UITextField with the specified design parameters.
    /// - Parameters:
    ///   - placeholder: Hint text in an empty field
    ///   - borderColor: Field border color
    ///   - borderWidth: Border thickness
    ///   - cornerRadius: Corner radius
    ///   - backgroundColor: Field background color
    ///   - textColor: Input text color
    /// - Returns: The configured UITextField
    func createTextField(placeholder: String,
                         borderColor: UIColor,
                         borderWidth: CGFloat,
                         cornerRadius: CGFloat,
                         backgroundColor: UIColor,
                         textColor: UIColor) -> UITextField
}


