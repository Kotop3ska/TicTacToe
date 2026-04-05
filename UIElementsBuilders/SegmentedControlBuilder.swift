//
//  SegmentedControlBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates UISegmentedControl.
class SegmentedControlBuilder: SegmentedControlBuilding {
    
    /// Singleton reference.
    static let shared = SegmentedControlBuilder()
    
    /// Prevents external initializing.
    private init() {}
    
    /// Creates UISegmentedControl with given parameters.
    /// - Parameters:
    ///   - items: Array of segment headers
    ///   - selectedIndex: Index of the selected segment
    ///   - selectedTintColor: The background color of the selected segment
    ///   - backgroundColor: The background color of the control
    ///   - selectedTextColor: The text color of the selected segment
    ///   - normalTextColor: Text color of inactive segments
    /// - Returns: Customized UISegmentedControl with autolayout
    func createSegmentedControl(items: [String],
                                selectedIndex: Int,
                                selectedTintColor: UIColor,
                                backgroundColor: UIColor?,
                                selectedTextColor: UIColor,
                                normalTextColor: UIColor) -> UISegmentedControl {
        
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = selectedIndex
        control.selectedSegmentTintColor = selectedTintColor
        control.backgroundColor = backgroundColor
        control.setTitleTextAttributes([.foregroundColor: selectedTextColor], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: normalTextColor], for: .normal)
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }
    
}
