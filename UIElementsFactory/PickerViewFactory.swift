//
//  PickerViewBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates UIPickerView.
class PickerViewFactory: PickerViewCreating {
    
    /// Singleton reference.
    static let shared = PickerViewFactory()
    
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
