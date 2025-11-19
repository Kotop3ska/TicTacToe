//
//  GameViewModel.swift
//  
//
//  Created by Dmitry on 11/4/25.
//

import Foundation

final class GameViewModel {
    // MARK: - Properties
    
    /// Current state of the game board
    private(set) var board: GameBoard
    
    /// Player X data
    private(set) var playerX: Player
    
    /// Player O data
    private(set) var playerO: Player
    
    /// Current player whose turn it is
    private(set) var currentPlayer: Player
    
    /// Bot player instance (if playing vs bot)
    private(set) var bot: BotPlayer?
    
    /// Flag indicating if the game is against a bot
    private var isPlayingWithBot = false
        
    // MARK: - Callbacks
    
    /// Called whenever the board changes to update the UI
    var onBoardChanged: (() -> Void)?
    
    /// Called when the game ends with the winner player or nil in case of draw
    var onGameEnded: ((Player?) -> Void)?
    
    /// Called when the bot makes a move
    var onBotMove: (() -> Void)?
    
    // MARK: - Init
    init(boardSize: Int,
         nameX: String,
         nameO: String,
         vsBot: Bool,
         humanPlaysAs type: Player.PlayerType?,
         botDifficulty: BotPlayer.BotDifficulty = .hard) {
        
        self.board = GameBoard(size: boardSize)
        self.playerX = Player(type: .x, name: nameX, winCounter: 0)
        self.playerO = Player(type: .o, name: nameO, winCounter: 0)
        self.currentPlayer = playerX
        self.isPlayingWithBot = vsBot
        if self.isPlayingWithBot {
            let playerType = type ?? .x
            let botType: Player.PlayerType = (playerType == .x) ? .o : .x
            self.bot = BotPlayer(type: botType, difficulty: botDifficulty)
        }
    }
    
    /// Convenience initializer for 2-player game without bot
    convenience init(boardSize: Int, nameX: String, nameO: String) {
        self.init(boardSize: boardSize, nameX: nameX, nameO: nameO, vsBot: false, humanPlaysAs: nil)
    }
    
    // MARK: - Public Methods
    
    /**
     Performs a move at the specified row and column for the current player.
     Updates game state, checks for a winner, and triggers callbacks.
    
     - Parameters:
        - row: row index
        - col: column index
    */
    func makeMove(row: Int, col: Int) {
        // Attempt to make the move on the board
        guard board.makeMove(atRow: row, col: col, for: currentPlayer.type) else { return }
        
        // Check for winner after move
        if let winner = board.checkWinner() {
            onBoardChanged?()
            switch winner {
            case playerX.type: 
                self.playerX.winCounter += 1
                onGameEnded?(playerX)
            case playerO.type:
                self.playerO.winCounter += 1
                onGameEnded?(playerO)
            default:
                break
            }
        } else {
            switchCurrentPlayer()
            
            // If it's bot's turn, schedule bot move
            if isPlayingWithBot && currentPlayer.type == bot?.type {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.performBotMove()
                }
            }
            onBoardChanged?()
        }
    }
    
    /// Attempts to perform a move made by the human player.
    /// Prevents input if it's currently the bot's turn.
    /// - Parameters:
    ///   - row: Row index tapped by the user.
    ///   - col: Column index tapped by the user.
    func makeHumanMove(row: Int, col: Int) {
        if isPlayingWithBot && currentPlayer.type == bot?.type { return }
        makeMove(row: row, col: col)
    }
    
    // MARK: - Bot Handling
    
    /// Performs the bot's move asynchronously
    private func performBotMove() {
        DispatchQueue.global().async {
            guard let move = self.bot?.bestMove(on: self.board) else { return }
            DispatchQueue.main.async {[weak self] in
                self?.onBotMove?()
                self?.makeMove(row: move.row, col: move.col)
            }
        }
    }
    
    // MARK: - Helpers
    
    /// Resets the game board and current player
    func resetGame() {
        board.reset()
        currentPlayer = playerX
        onBoardChanged?()
    }
    
    /// Starts the game automatically if bot is the first player
    func startGameIfBotFirst() {
        guard isPlayingWithBot && currentPlayer.type == bot?.type else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.performBotMove()
        }
    }
    
    /// Switches the current player to the other one
    private func switchCurrentPlayer() {
        currentPlayer = (currentPlayer.type == playerX.type) ? playerO : playerX
    }
}

