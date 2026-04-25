//
//  UIElementsBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Provides a single interface for accessing all UI component builders.
public class UIFactory {
    
    /// Returns a single instance of the facade builder.
    public static let shared = UIFactory()
    
    /// Prevents external initialization.
    private init() {}
    
    /// Returns a builder for creating buttons.
    public var buttonBuilder: any ButtonCreating { ButtonFactory.shared }
    
    /// Returns a builder for creating text labels.
    public var labelBuilder: any LableCreating { LabelFactory.shared }
    
    /// Returns a builder for creating text fields.
    public var textFieldBuilder: any TextFieldCreating { TextFieldFactory.shared }
    
    /// Returns a builder for creating segmented controls.
    public var segmentedControlBuilder: any SegmentedControlCreating { SegmentedControlFactory.shared }
    
    /// Returns the builder for creating a scroll view.
    public var scrollViewBuilder: any ScrollViewCreating { ScrollViewFactory.shared }
    
    /// Returns a builder for creating images.
    public var imageViewBuilder: any ImageViewCreating { ImageViewFactory.shared }
    
    /// Returns a builder for creating switches.
    public var switchBuilder: any SwitchCreating { SwitchFactory.shared }
    
    /// Returns a builder for creating pickers.
    public var pickerBuilder: any PickerViewCreating { PickerViewFactory.shared }
    
    /// Returns a builder for creating stacks.
    public var stackBuilder: any StackViewCreating { StackViewFactory.shared }
}

