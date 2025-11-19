//
//  BotPlayer.swift
//  TicTacToe
//
//  Created by Dmitry on 11/10/25.
//

final class BotPlayer {
    
    // MARK: - Properties
    private(set) var type: Player.PlayerType
    private let opponentType: Player.PlayerType
    private let difficulty: BotDifficulty
    
    // MARK: - Init
    init(type: Player.PlayerType, difficulty: BotDifficulty = .hard) {
        self.type = type
        self.opponentType = (type == .x) ? .o : .x
        self.difficulty = difficulty
    }
    
    // MARK: - Public Method
    
    /// Returns the bot's next move based on the selected difficulty level.
    func bestMove(on board: GameBoard) -> (row: Int, col: Int)? {
        switch difficulty {
        case .easy:
            // Easy: 30% chance to choose optimal move, otherwise random
            if Bool.random(probability: 0.3), let move = optimalMove(on: board) {
                return move
            } else {
                return randomMove(on: board)
            }
            
        case .medium:
            // Medium: 70% chance to choose optimal move, otherwise random
            if Bool.random(probability: 0.7), let move = optimalMove(on: board) {
                return move
            } else {
                return randomMove(on: board)
            }
            
        case .hard:
            // Hard: always choose the optimal move
            return optimalMove(on: board)
        }
    }
    
    // MARK: - Helpers
    
    /// Returns a random empty cell on the board
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
    
    /// Returns the optimal move following the strategy:
    /// 1. Win if possible
    /// 2. Block opponent's winning move
    /// 3. Take center if available
    /// 4. Take a random corner if available
    /// 5. Take a random side if available
    /// 6. Otherwise, take the first empty cell
    private func optimalMove(on board: GameBoard) -> (row: Int, col: Int)? {
        if let winningMove = findWinningMove(for: type, on: board) {
            return winningMove
        }
        
        if let blockMove = findWinningMove(for: opponentType, on: board) {
            return blockMove
        }
        
        let center = board.boardSize / 2
        if board[center, center] == nil {
            return (center, center)
        }
        
        let corners = [
            (0,0),
            (0,board.boardSize-1),
            (board.boardSize-1,0),
            (board.boardSize-1, board.boardSize-1)
        ]
        let freeCorners = corners.filter { board[$0.0, $0.1] == nil }
        if let corner = freeCorners.randomElement() {
            return corner
        }
        
        var sides: [(Int, Int)] = []
        for i in 1..<board.boardSize-1 {
            sides.append((0,i))
            sides.append((board.boardSize-1, i))
            sides.append((i,0))
            sides.append((i,board.boardSize-1))
        }
        let freeSides = sides.filter { board[$0.0, $0.1] == nil }
        if let side = freeSides.randomElement() {
            return side
        }
        
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                if board[row, col] == nil {
                    return (row, col)
                }
            }
        }
        return nil
    }
        
    /// Checks if a winning move is available for the given player
    private func findWinningMove(for player: Player.PlayerType, on board: GameBoard) -> (row: Int, col: Int)? {
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                if board[row, col] == nil {
                    board[row, col] = player
                    if board.checkWinner() == player {
                        board[row, col] = nil
                        return (row, col)
                    }
                    board[row, col] = nil
                }
            }
        }
        return nil
    }
}

// MARK: - Difficulty Enum
extension BotPlayer {
    /// Defines bot difficulty levels
    enum BotDifficulty {
        case easy
        case medium
        case hard
    }
}

// MARK: - Bool probability helper
extension Bool {
    /// Returns true with the given probability (0.0 - 1.0)
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0..<1) < probability
    }
}
