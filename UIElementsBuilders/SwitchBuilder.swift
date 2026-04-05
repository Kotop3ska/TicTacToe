//
//  SwitchBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates and configures a UISwitch.
class SwitchBuilder: SwitchBuilding {
    
    /// Singleton reference.
    static let shared = SwitchBuilder()
    
    /// Prevents external initializing.
    private init() {}
    
    /// Creates a basic UISwitch.
    /// - Returns: The configured UISwitch
    func createSwitch() -> UISwitch {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }
}
