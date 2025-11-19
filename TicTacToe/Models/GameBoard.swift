//
//  GameBoard.swift
//  TicTacToe
//
//  Created by Dmitry on 11/3/25.
//

final class GameBoard {
    
    // MARK: - Properties
    private(set) var cells: [Player.PlayerType?]
    internal var moveHistory: [(row: Int, col: Int)]
    private(set) var boardSize: Int
    private(set) var winningLine: [(Int, Int)]? = nil
    private let maxActiveMovesOffset = 3
    /// Precomputed list of all winning lines (rows, columns, diagonals)
    private(set) lazy var allLines: [[(Int, Int)]] = generateAllLines()
    
    // MARK: - Init
    init(size: Int) {
        self.boardSize = size
        self.cells = Array(repeating: nil, count: size * size)
        self.moveHistory = []
    }
    
    // MARK: - Subscript
    /// Accesses a cell by its row and column.
    subscript(row: Int, col: Int) -> Player.PlayerType? {
        get {
            guard isValuesInRange(atRow: row, col: col) else { return nil }
            return cells[index(for: row, col: col)]
        }
        set {
            guard isValuesInRange(atRow: row, col: col) else { return }
            cells[index(for: row, col: col)] = newValue
        }
    }
    
    // MARK: - Public Methods
    
    /// Fills the specified cell with the player's mark. Returns true if successful.
    func makeMove(atRow row: Int, col: Int, for player: Player.PlayerType) -> Bool {
        guard isValuesInRange(atRow: row, col: col), isCellEmpty(atRow: row, col: col) else { return false }
        
        self[row, col] = player
        moveHistory.append((row, col))
        
        if isLimit() {
            let oldestMove = moveHistory.removeFirst()
            self[oldestMove.row, oldestMove.col] = nil
        }
        return true
    }
    
    /// Determines the winner; returns nil if no winner exists.
    func checkWinner() -> Player.PlayerType? {
        for line in allLines {
            let symbols = line.compactMap { self[$0.0, $0.1] }
            if symbols.count == boardSize, Set(symbols).count == 1 {
                winningLine = line
                return symbols.first
            }
        }
        return nil
    }
    
    /// Resets the game board to its initial empty state.
    func reset() {
        cells = Array(repeating: nil, count: boardSize * boardSize)
        moveHistory.removeAll()
        winningLine = nil
    }
}

// MARK: - Helpers

extension GameBoard {
    
    /// Returns true if the specified cell is empty.
    private func isCellEmpty(atRow row: Int, col: Int) -> Bool {
        return self[row, col] == nil
    }
    
    /// Checks whether the provided coordinates are within board bounds.
    private func isValuesInRange(atRow row: Int, col: Int) -> Bool {
        return (row >= 0) && (row < boardSize) && (col >= 0) && (col < boardSize)
    }
    
    /// Returns true if the limit of active moves has been exceeded.
    private func isLimit() -> Bool {
        let maxMoves = boardSize * boardSize - maxActiveMovesOffset
        return moveHistory.count > maxMoves
    }
    
    /// Converts (row, col) into a linear array index.
    private func index(for row: Int, col: Int) -> Int {
        row * boardSize + col
    }
    
    /// Generates all winning lines (rows, columns, both diagonals).
    private func generateAllLines() -> [[(Int, Int)]] {
        var lines: [[(Int, Int)]] = []

        for row in 0..<boardSize {
            lines.append((0..<boardSize).map { (row, $0) })
        }
        for col in 0..<boardSize {
            lines.append((0..<boardSize).map { ($0, col) })
        }
        lines.append((0..<boardSize).map { ($0, $0) })
        lines.append((0..<boardSize).map { ($0, boardSize - 1 - $0) })

        return lines
    }
}
