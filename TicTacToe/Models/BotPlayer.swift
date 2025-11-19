//
//  BotPlayer.swift
//  TicTacToe
//
//  Created by Dmitry on 11/3/25.
//


final class BotPlayer {
    
    // MARK: - Properties
    
    /// Type of the bot (X or O)
    private(set) var type: Player.PlayerType
    
    /// Type of the opponent
    private let opponentType: Player.PlayerType
    
    /// Difficulty level of the bot
    private let difficulty: BotDifficulty
    
    // MARK: - Constants
    
    private let easyProbability = 0.3
    private let mediumProbability = 0.7
    private let winScore = 10
    private let loseScore = -100
    private let drawScore = 0
    private let opponentBlockMultiplier = 2
    private let maxDepthLimit = 5
    
    // MARK: - Init
    
    /// Initializes the bot with a type and difficulty level
    init(type: Player.PlayerType, difficulty: BotDifficulty = .hard) {
        self.type = type
        self.opponentType = (type == .x) ? .o : .x
        self.difficulty = difficulty
    }
    
    // MARK: - Public Methods
    
    /// Returns the best move for the bot on the current board
    /// - Parameter board: The current game board
    /// - Returns: A tuple (row, col) representing the move
    func bestMove(on board: GameBoard) -> (row: Int, col: Int)? {
        switch difficulty {
        case .easy:
            if Bool.random(probability: easyProbability), let move = minimaxMove(on: board) {
                return move
            } else {
                return randomMove(on: board)
            }
        case .medium:
            if Bool.random(probability: mediumProbability), let move = minimaxMove(on: board) {
                return move
            } else {
                return randomMove(on: board)
            }
        case .hard:
            return minimaxMove(on: board)
        }
    }
    
    // MARK: - Helpers
    
    /// Returns a random move from available cells
    private func randomMove(on board: GameBoard) -> (row: Int, col: Int)? {
        var emptyCells: [(Int, Int)] = []
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                if board[row, col] == nil {
                    emptyCells.append((row, col))
                }
            }
        }
        return emptyCells.randomElement()
    }
    
    /// Returns the move chosen by minimax
    private func minimaxMove(on board: GameBoard) -> (row: Int, col: Int)? {
        var bestScore = Int.min
        var move: (Int, Int)?
        
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                if board[row, col] == nil {
                    board[row, col] = type
                    let score = minimax(board: board, depth: 0, isMaximizing: false)
                    board[row, col] = nil
                    if score > bestScore {
                        bestScore = score
                        move = (row, col)
                    }
                }
            }
        }
        return move
    }
    
    /// Recursive minimax function with optional evaluation for limited depth
    private func minimax(board: GameBoard, depth: Int, isMaximizing: Bool) -> Int {
        if let winner = board.checkWinner() {
            if winner == type {
                return winScore - depth
            } else if winner == opponentType {
                return depth + loseScore
            } else {
                return drawScore
            }
        }
        
        if depth >= maxDepthLimit {
            return evaluateBoard(board)
        }
        
        var bestScore = isMaximizing ? Int.min : Int.max
        
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                if board[row, col] == nil {
                    board[row, col] = isMaximizing ? type : opponentType
                    let score = minimax(board: board, depth: depth + 1, isMaximizing: !isMaximizing)
                    board[row, col] = nil
                    
                    if isMaximizing {
                        bestScore = max(score, bestScore)
                    } else {
                        bestScore = min(score, bestScore)
                    }
                }
            }
        }
        
        return bestScore
    }
    
    /// Evaluation function to prioritize own lines and block opponent
    private func evaluateBoard(_ board: GameBoard) -> Int {
        var score = 0
        for line in board.allLines {
            let cellsInLine = line.map { board[$0.0, $0.1] }
            let botCount = cellsInLine.filter { $0 == type }.count
            let oppCount = cellsInLine.filter { $0 == opponentType }.count
            
            if botCount > 0 && oppCount == 0 {
                score += botCount
            } else if oppCount > 0 && botCount == 0 {
                score -= oppCount * opponentBlockMultiplier
            }
        }
        return score
    }
}

// MARK: - Difficulty Enum
extension BotPlayer {
    /// Bot difficulty levels
    enum BotDifficulty {
        case easy
        case medium
        case hard
    }
}

// MARK: - Bool probability helper
extension Bool {
    /// Returns true with given probability
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0..<1) < probability
    }
}

// MARK: - GameBoard cloning helper (optional)
extension GameBoard {
    /// Returns a copy of the board for safe simulation
    func clone() -> GameBoard {
        let copy = GameBoard(size: self.boardSize)
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                copy[row, col] = self[row, col]
            }
        }
        copy.moveHistory = self.moveHistory
        return copy
    }
}
