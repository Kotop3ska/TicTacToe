//
//  UIElementsBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Provides a single interface for accessing all UI component builders.
public class UIBuilder {
    
    /// Returns a single instance of the facade builder.
    public static let shared = UIBuilder()
    
    /// Prevents external initialization.
    private init() {}
    
    /// Returns a builder for creating buttons.
    public var buttonBuilder: any ButtonBuilding { ButtonBuilder.shared }
    
    /// Returns a builder for creating text labels.
    public var labelBuilder: any LableBuilding { LabelBuilder.shared }
    
    /// Returns a builder for creating text fields.
    public var textFieldBuilder: any TextFieldBuilding { TextFieldBuilder.shared }
    
    /// Returns a builder for creating segmented controls.
    public var segmentedControlBuilder: any SegmentedControlBuilding { SegmentedControlBuilder.shared }
    
    /// Returns the builder for creating a scroll view.
    public var scrollViewBuilder: any ScrollViewBuilding { ScrollViewBuilder.shared }
    
    /// Returns a builder for creating images.
    public var imageViewBuilder: any ImageViewBuilding { ImageViewBuilder.shared }
    
    /// Returns a builder for creating switches.
    public var switchBuilder: any SwitchBuilding { SwitchBuilder.shared }
    
    /// Returns a builder for creating pickers.
    public var pickerBuilder: any PickerViewBuilding { PickerViewBuilder.shared }
    
    /// Returns a builder for creating stacks.
    public var stackBuilder: any StackViewBuilding { StackViewBuilder.shared }
}

