//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Dmitry on 11/3/25.
//

/// Implements a game board for tic-tac-toe.
public final class GameBoard {
    
    // MARK: - Properties
    
    /// Cells state.
    private(set) var cells: [Player.PlayerType?]
    
    /// Information about moves.
    internal var moveHistory: [(row: Int, col: Int)]
    
    /// Size of a game board.
    public private(set) var boardSize: Int
    
    /// Winning line coordinates after a win.
    public private(set) var winningLine: [(Int, Int)]? = nil
    
    /// Precomputed list of all winning lines (rows, columns, diagonals).
    private(set) lazy var allLines: [[(Int, Int)]] = generateAllLines()
    
    // MARK: - Constants
    
    /// Reserve of cells when calculating the limit of active moves.
    private let maxActiveMovesOffset = 3
    
    // MARK: - Init
    
    /// Initializes empty board.
    public init(size: Int) {
        self.boardSize = abs(size)
        self.cells = Array(repeating: nil, count: size * size)
        self.moveHistory = []
    }
    
    // MARK: - Subscript
    
    /// Provides accesses a cell by its row and column.
    public subscript(row: Int, col: Int) -> Player.PlayerType? {
        get {
            guard isValuesInRange(atRow: row, col: col) else { return nil }
            return self.cells[index(for: row, col: col)]
        }
        set {
            guard isValuesInRange(atRow: row, col: col) else { return }
            self.cells[index(for: row, col: col)] = newValue
        }
    }
    
    // MARK: - Public methods
    
    /// Fills the specified cell with the player's mark.
    /// - Parameters:
    ///   - row: Target cell row
    ///   - col: Target cell col
    ///   - player: Player type
    /// - Returns: `true` if successful, otherwise `false`
    public func makeMove(atRow row: Int, col: Int, for player: Player.PlayerType) -> Bool {
        guard isValuesInRange(atRow: row, col: col), isCellEmpty(atRow: row, col: col) else { return false }
        
        self[row, col] = player
        self.moveHistory.append((row, col))
        
        if isLimit() {
            let oldestMove = self.moveHistory.removeFirst()
            self[oldestMove.row, oldestMove.col] = nil
        }
        return true
    }
    
    /// Determines the winner.
    /// - Returns: Player type or `nil` if no winner exists.
    public func checkWinner() -> Player.PlayerType? {
        for line in self.allLines {
            let symbols = line.compactMap { self[$0.0, $0.1] }
            if symbols.count == self.boardSize, Set(symbols).count == 1 {
                self.winningLine = line
                return symbols.first
            }
        }
        return nil
    }
    
    /// Resets the game board to its initial empty state.
    public func reset() {
        self.cells = Array(repeating: nil, count: self.boardSize * self.boardSize)
        self.moveHistory.removeAll()
        self.winningLine = nil
    }

// MARK: - Private methods
    
    /// Сhecks if a cell is emptyю
    /// - Returns: `true` if the specified cell is empty.
    private func isCellEmpty(atRow row: Int, col: Int) -> Bool {
        return self[row, col] == nil
    }
    
    /// Checks whether the provided coordinates are within board bounds.
    /// - Returns: `true` if coordinates are within board bounds
    private func isValuesInRange(atRow row: Int, col: Int) -> Bool {
        return (row >= 0) && (row < self.boardSize) && (col >= 0) && (col < self.boardSize)
    }
    
    /// Determines whether the active moves limit has been exceeded.
    /// - Returns: `true` if the oldest move should be deleted
    private func isLimit() -> Bool {
        let maxMoves = self.boardSize * self.boardSize - self.maxActiveMovesOffset
        return self.moveHistory.count > maxMoves
    }
    
    /// Converts (row, col) into a linear array index.
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    /// - Returns: A linear array index
    private func index(for row: Int, col: Int) -> Int {
        return row * self.boardSize + col
    }
    
    /// Generates all winning lines (rows, columns, both diagonals).
    /// - Returns: Array of winning lines
    private func generateAllLines() -> [[(Int, Int)]] {
        var lines: [[(Int, Int)]] = []
            
        lines.append(contentsOf: generateHorizontalLines())
        lines.append(contentsOf: generateVerticalLines())
        lines.append(generateMainDiagonal())
        lines.append(generateAntiDiagonal())

        return lines
    }
    
    /// Generates horizontal winning lines (rows, columns, both diagonals).
    /// /// - Returns: Array of horizontal winning lines
    private func generateHorizontalLines() -> [[(Int, Int)]] {
        return (0..<self.boardSize).map { row in
            (0..<self.boardSize).map { (row, $0) }
        }
    }
    
    /// Generates vertical winning lines (rows, columns, both diagonals).
    /// - Returns: Array of vertical winning lines
    private func generateVerticalLines() -> [[(Int, Int)]] {
        return (0..<boardSize).map { col in
            (0..<boardSize).map { ($0, col) }
        }
    }
    
    /// Generates winning line from main diagonal (rows, columns, both diagonals).
    /// - Returns: winning line from main diagonal
    private func generateMainDiagonal() -> [(Int, Int)] {
        return (0..<boardSize).map { ($0, $0) }
    }
    
    /// Generates winning line from anti diagonal (rows, columns, both diagonals).
    /// - Returns: winning line from anti diagonal
    private func generateAntiDiagonal() -> [(Int, Int)] {
        return (0..<boardSize).map { ($0, boardSize - 1 - $0) }
    }
}
