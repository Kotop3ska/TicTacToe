//
//  PickerViewBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates UIPickerView.
class PickerViewBuilder: PickerViewBuilding {
    
    /// Singleton reference.
    static let shared = PickerViewBuilder()
    
    /// Prevents external initializing.
    private init() {}
    
    /// Creates picker.
    /// - Returns: UIPickerView
    func createPicker() -> UIPickerView {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }
}
