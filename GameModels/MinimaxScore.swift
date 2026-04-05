//
//  MinimaxScore.swift
//  TicTacToe
//
//  Created by Dmitry on 3/30/26.
//

/// Defines numerical scores for the Minimax algorithm.
enum MinimaxScore: Int {
    
    /// Winning position score.
    case winScore = 10
    
    /// Losing position score.
    case loseScore = -100
    
    /// Draw score.
    case drawScore = 0
}
