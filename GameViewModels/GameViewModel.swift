//
//  GameViewModel.swift
//  
//
//  Created by Dmitry on 11/4/25.
//

import Foundation
import GameModels

/// Manages game logic, board state, and player interactions.
public final class GameViewModel {
    
    // MARK: - Properties
    
    /// Current state of the game board.
    public private(set) var board: GameBoard
    
    /// Player X data.
    public private(set) var playerX: Player
    
    /// Player O data.
    public private(set) var playerO: Player
    
    /// Current player whose turn it is.
    public private(set) var currentPlayer: Player
    
    /// Bot player instance (if playing vs bot).
    public private(set) var bot: BotPlayer?
    
    /// Flag indicating if the game is against a bot.
    private var isPlayingWithBot = false
        
    // MARK: - Callbacks
    
    /// Called whenever the board changes to update the UI.
    public var onBoardChanged: (() -> Void)?
    
    /// Called when the game ends with the winner player or nil in case of draw.
    public var onGameEnded: ((Player?) -> Void)?
    
    /// Called when the bot makes a move.
    public var onBotMove: (() -> Void)?
    
    // MARK: - Init
    
    /// Initializes the game with the given parameters.
    /// - Parameters:
    ///   - boardSize: Game board size (N×N)
    ///   - nameX: Name of player X
    ///   - nameO: Name of player O
    ///   - vsBot: Flag for playing against a bot
    ///   - humanPlaysAs: Piece type for a human (if playing against a bot)
    ///   - botDifficulty: Bot difficulty level (default: .hard)
    public init(boardSize: Int,
         nameX: String,
         nameO: String,
         vsBot: Bool,
         humanPlaysAs type: Player.PlayerType?,
         botDifficulty: Difficulty = .hard) {
        
        self.board = GameBoard(size: boardSize)
        self.playerX = Player(type: .x, name: nameX, winCounter: 0)
        self.playerO = Player(type: .o, name: nameO, winCounter: 0)
        self.currentPlayer = self.playerX
        self.isPlayingWithBot = vsBot
        if self.isPlayingWithBot {
            let playerType = type ?? .x
            let botType: Player.PlayerType = (playerType == .x) ? .o : .x
            self.bot = BotPlayer(type: botType, difficulty: botDifficulty)
        }
    }
    
    // Initializes a two-player game without a bot.
    /// - Parameters:
    ///   - boardSize: Board size
    ///   - nameX: Name of player X
    ///   - nameO: Name of player O
    public convenience init(boardSize: Int, nameX: String, nameO: String) {
        self.init(boardSize: boardSize, nameX: nameX, nameO: nameO, vsBot: false, humanPlaysAs: nil)
    }
    
    // MARK: - Public methods
    
    /// Performs the current player's move to the specified position.
    /// - Parameters:
    ///   - row: Row index
    ///   - col: Column index
    public func makeMove(row: Int, col: Int) {
        guard self.tryApplyMove(row: row, col: col) else { return }
        
        if checkAndHandleWin() {
            return
        }
        
        handleGameContinuation()
    }
    
    /// Handles human input, blocking input during bot input.
    /// - Parameters:
    /// - row: Index of the row selected by the user
    /// - col: Index of the column selected by the user
    public func makeHumanMove(row: Int, col: Int) {
        guard canHumanMakeMove() else { return }
        makeMove(row: row, col: col)
    }
    
    /// Resets the game board and current player.
    public func resetGame() {
        self.board.reset()
        self.currentPlayer = self.playerX
        self.onBoardChanged?()
    }
    
    /// Starts the game automatically if bot is the first player.
    public func startGameIfBotFirst() {
        guard self.isPlayingWithBot && self.currentPlayer.type == self.bot?.type else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.performBotMove()
        }
    }
    
    // MARK: - Private methods
    
    /// Performs the bot's move asynchronously in a background thread.
    private func performBotMove() {
        DispatchQueue.global().async {
            guard let move = self.bot?.move(on: self.board) else { return }
            DispatchQueue.main.async {[weak self] in
                self?.onBotMove?()
                self?.makeMove(row: move.row, col: move.col)
            }
        }
    }
    
    /// Checks whether a human can make a move at the current moment.
    /// - Returns: `true` if input is not blocked by a bot
    private func canHumanMakeMove() -> Bool {
        return !(self.isPlayingWithBot && self.currentPlayer.type == self.bot?.type)
    }
    
    /// Attempts to apply a move to the board.
    /// - Returns: `true` if the move was successfully applied
    private func tryApplyMove(row: Int, col: Int) -> Bool {
        self.board.makeMove(atRow: row, col: col, for: self.currentPlayer.type)
    }
    
    /// Checks for a win and handles game completion.
    /// - Returns: `true` if the game is over
    private func checkAndHandleWin() -> Bool {
        guard let winner = self.board.checkWinner() else { return false }
        
        self.onBoardChanged?()
        recordWin(for: winner)
        self.onGameEnded?(self.getWinnerPlayer(winner))
        
        return true
    }
    
    /// Returns a player object based on the winner's piece type.
    /// - Parameter winner: The winner's piece type (.x or .o)
    /// - Returns: The corresponding Player object
    private func getWinnerPlayer(_ winner: Player.PlayerType) -> Player {
        return winner == self.playerX.type ? self.playerX : self.playerO
    }
    
    /// Handles the continuation of the game: player change and bot turn.
    private func handleGameContinuation() {
        switchCurrentPlayer()
        
        if shouldBotMoveNow() {
            scheduleBotMove()
        }
        
        self.onBoardChanged?()
    }
    
    /// Checks if it is the bot's turn.
    /// - Returns: `true` if the bot should take a turn
    private func shouldBotMoveNow() -> Bool {
        return self.isPlayingWithBot && self.currentPlayer.type == self.bot?.type
    }
    
    /// Plans the bot's move with a slight delay for naturalness.
    private func scheduleBotMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performBotMove()
        }
    }
    
    /// Records the victory in the player's statistics.
    /// - Parameter winner: The winner's body type
    private func recordWin(for winner: Player.PlayerType) {
        if winner == self.playerX.type {
            self.playerX.addWin()
        } else if winner == self.playerO.type {
            self.playerO.addWin()
        }
    }
    
    /// Switches the current player to the other one.
    private func switchCurrentPlayer() {
        self.currentPlayer = (self.currentPlayer.type == self.playerX.type) ? self.playerO : self.playerX
    }
}

