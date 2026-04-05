//
//  Difficulty.swift
//  TicTacToe
//
//  Created by Dmitry on 3/30/26.
//

/// Determins the bot's difficulty levels through the probability of choosing the optimal move.
public enum Difficulty: Double {
    
    /// The optimal move will be chosen with probability of 0.3, otherwise the move will be random.
    case easy = 0.3
    
    // The optimal move will be chosen with probability of 0.7, otherwise the move will be random.
    case medium = 0.7
    
    // The optimal move will be chosen with probability of 1.0, otherwise the move will be random.
    case hard = 1.0
}
