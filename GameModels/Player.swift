//
//  Player.swift
//  TicTacToe
//
//  Created by Dmitry on 11/3/25.
//

import UIKit

/// Represents the player. Stores figure type, player name and win statistic information.
public struct Player {
    
    /// Type of player.
    public let type: PlayerType
    
    /// Player name.
    public private(set) var name: String
    
    /// Victory counter.
    public private(set) var winCounter: Int
    
    /// initialize player
    public init(type: PlayerType, name: String, winCounter: Int) {
            self.type = type
            self.name = name
            self.winCounter = winCounter
        }
    
    /// Increases ``winCounter`` by 1
    public mutating func addWin() {
        self.winCounter += 1
    }
}

extension Player {
    
    /// Identifies possible figures types.
    public enum PlayerType {
        case x
        case o
    }
}



