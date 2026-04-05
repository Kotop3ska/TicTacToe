//
//  BotPlayer.swift
//  TicTacToe
//
//  Created by Dmitry on 11/3/25.
//

/// Implements a gaming bot with Minimax algorithm. Supports  difficulty adjustments through probabilistic choises between optimal and random moves.
public final class BotPlayer {
    
    // MARK: - Properties
    
    /// Type of the bot.
    public private(set) var type: Player.PlayerType
    
    /// Type of the opponent.
    private let opponentType: Player.PlayerType
    
    /// Difficulty level of the bot;
    private let difficulty: Difficulty
    
    // MARK: - Constants
    
    /// Priority factor for blocking opponent moves.
    private let opponentBlockMultiplier = 2
    
    /// Recursion limit for Minimax
    private let maxDepthLimit = 5
    
    // MARK: - Init
    
    /// Initializes the bot with a type and difficulty level
    public init(type: Player.PlayerType, difficulty: Difficulty = .hard) {
        self.type = type
        self.opponentType = (type == .x) ? .o : .x
        self.difficulty = difficulty
    }
    
    // MARK: - Public methods
    
    /// Returns the best move for the bot on the current board
    /// - Parameter board: The current game board
    /// - Returns: A tuple (row, col) representing the move
    public func move(on board: GameBoard) -> (row: Int, col: Int)? {
        return selectMove(on: board, byProbability: self.difficulty.rawValue)
    }
    
    // MARK: - Private methods
    
    /// Selects move depending on probability.
    /// - Parameters:
    ///   - board: Current game board state
    ///   - probability: Optimal move probability
    /// - Returns: Selected move coordinates or `nil`
    private func selectMove(on board: GameBoard, byProbability probability: Double) -> (row: Int, col: Int)? {
        if Bool.isTrueWith(probability: probability), let move = getMinimaxMove(on: board) {
            return move
        } else {
            return getRandomMove(on: board)
        }
    }
    
    /// Finds all empty cells on the game board.
    /// - Parameter board: Current game board state
    /// - Returns: Tuples array `[(row: Int, col: Int)]` with empty cells coordinates
    private func findEmptyCells(on board: GameBoard) -> [(row: Int, col: Int)] {
        var emptyCells: [(Int, Int)] = []
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                if board[row, col] == nil {
                    emptyCells.append((row, col))
                }
            }
        }
        return emptyCells
    }
    
    /// Evaluates a potential move.
    /// - Parameters:
    ///   - row: Target cell row
    ///   - col: Target cell column
    ///   - board: Current game board state
    /// - Returns: The numerical value of the move or `nil` if the cell is not empty
    private func evaluateMove(row: Int, col: Int, on board: GameBoard) -> Int? {
        guard board[row, col] == nil else { return nil }
        
        board[row, col] = self.type
        let score = calculateMinimaxScore(board: board, depth: 0, isMaximizing: false)
        board[row, col] = nil
        
        return score
    }
    
    /// Returns a random move from available cells.
    /// - Parameter board: Current game board state
    /// - Returns: Random coordinates or `nil` if cell not empty
    private func getRandomMove(on board: GameBoard) -> (row: Int, col: Int)? {
        let emptyCells = findEmptyCells(on: board)
        return emptyCells.randomElement()
    }
    
    /// Returns the move chosen by minimax.
    /// - Parameter board: Current game board state
    /// - Returns: The best coordinates or `nil` if cell not empty
    private func getMinimaxMove(on board: GameBoard) -> (row: Int, col: Int)? {
        var bestScore = Int.min
        var move: (Int, Int)?
        
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                if let score = evaluateMove(row: row, col: col, on: board) {
                    if score > bestScore {
                        bestScore = score
                        move = (row, col)
                    }
                }
            }
        }
        return move
    }
    
    /// Checks for a winner.
    ///  - Parameters:
    ///    - board: Current game board state
    ///    - depth: Current depth
    ///  - Returns: Evaluetion of terminal state or `nil` if the game continues
    private func checkTerminalState(board: GameBoard, depth: Int) -> Int? {
        guard let winner = board.checkWinner() else { return nil }
        
        switch winner {
        case self.type: return MinimaxScore.winScore.rawValue - depth
        case self.opponentType: return depth + MinimaxScore.loseScore.rawValue
        default: return MinimaxScore.drawScore.rawValue
        }
    }
    
    /// Find best score for current player.
    /// - Parameters:
    ///   - board: Current game board state
    ///   - depth: Current depth
    ///   - isMaximizing: `true` if the maximizing player move else `false`
    /// - Returns: Numerical evaluetion of position
    private func findBestScore(board: GameBoard, depth: Int, isMaximizing: Bool) -> Int {
        var bestScore = isMaximizing ? Int.min : Int.max
        
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                if let score = evaluateCell(row: row, col: col, board: board, depth: depth, isMaximizing: isMaximizing) {
                    bestScore = isMaximizing ? max(score, bestScore) : min(score, bestScore)
                }
            }
        }
        return bestScore
    }
    
    /// Evaluate specific cell.
    /// - Parameters:
    ///   - row: Cell row
    ///   - col: Cell column
    ///   - board: Current game board state
    ///   - depth: Current depth
    ///   - isMaximizing: `true` if the maximizing player move else `false`
    /// - Returns: Evaluation of move  or `nil` if cel isl not empty
    private func evaluateCell(row: Int, col: Int, board: GameBoard, depth: Int, isMaximizing: Bool) -> Int? {
        guard board[row, col] == nil else { return nil }
        
        board[row, col] = isMaximizing ? self.type : self.opponentType
        let score = calculateMinimaxScore(board: board, depth: depth + 1, isMaximizing: !isMaximizing)
        board[row, col] = nil
        
        return score
    }
    
    /// Calculates score from Minimax algorithm.
    /// - Parameters:
    ///   - board: Current game board state
    ///   - depth: Current game board state
    ///   - isMaximizing: `true` if the maximizing player move else `false`
    /// - Returns: Numerical evaluetion of position for the bot
    private func calculateMinimaxScore(board: GameBoard, depth: Int, isMaximizing: Bool) -> Int {
        if let terminalScore = checkTerminalState(board: board, depth: depth) {
            return terminalScore
        }
        
        if depth >= self.maxDepthLimit {
            return evaluateBoard(board)
        }
        
        return findBestScore(board: board, depth: depth, isMaximizing: isMaximizing)
    }
    
    /// Evaluates the board: prioritizes your own lines and blocks the opponent.
    /// - Parameter board:Current game board state
    /// - Returns: Numerical evaluation of the position
    private func evaluateBoard(_ board: GameBoard) -> Int {
        var score = 0
        for line in board.allLines {
            let cellsInLine = line.map { board[$0.0, $0.1] }
            let botCount = cellsInLine.filter { $0 == self.type }.count
            let oppCount = cellsInLine.filter { $0 == self.opponentType }.count
            
            if botCount > 0 && oppCount == 0 {
                score += botCount
            } else if oppCount > 0 && botCount == 0 {
                score -= oppCount * self.opponentBlockMultiplier
            }
        }
        return score
    }
}

// MARK: - Bool probability helper

extension Bool {
    
    /// Returns `true` with given probability.
    /// - Parameter probability: Probability
    /// - Returns: `true` if random value less probability
    static func isTrueWith(probability: Double) -> Bool {
        return Double.random(in: 0..<1) < probability
    }
}

// MARK: - GameBoard cloning helper

extension GameBoard {
    
    /// Returns a copy of the board for safe simulation.
    /// - Returns: copy of game board
    public func clone() -> GameBoard {
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
