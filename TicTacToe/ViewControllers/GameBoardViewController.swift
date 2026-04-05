//
//  GameBoardViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/5/25.
//

import UIKit
import UIElementsBuilders
import AppResources
import GameBoardViews
import GameModels
import GameViewModels

/// Displays the interactive game board and manages gameplay UI updates.
final class GameBoardViewController: UIViewController {

    // MARK: - Properties
    
    /// The game logic and state management
    private var viewModel: GameViewModel
    
    /// The interactive tic-tac-toe board.
    private(set) lazy var boardView = BoardView(boardSize: viewModel.board.boardSize)
    
    /// Name of the current player.
    private(set) lazy var currentPlayerLabel = createLabel(text: "", color: .playerXColor, fontSize: 28)
    
    /// The win score for both players.
    private(set) lazy var scoreLabel = createLabel(text: "\(viewModel.playerX.winCounter) : \(viewModel.playerO.winCounter)",
                                                   color: .black,
                                                   fontSize: 40)
    
    /// Provides access to UI component builders.
    private let elementsBuilder = UIBuilder.shared

    // MARK: - Init
    
    /// Initializes the controller with a game view model.
    /// - Parameter viewModel: GameViewModel instance managing game logic
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    
    /// Configures the UI, binds viewModel callbacks, and updates initial state.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        updateCurrentPlayerLabel()
        setupNavigationItem()
    }

    /// Starts the game automatically if the bot moves first.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startGameIfBotFirst()
    }

    // MARK: - Setup UI
    
    /// Adds subviews, configures properties, constraints, and callbacks.
    private func setupUI() {
        addSubviews()
        setupBoardViewProperties()
        setupConstraints()
        setupCallbacks()
    }

    /// Adds labels and board view to the view hierarchy.
    private func addSubviews() {
        view.addSubview(currentPlayerLabel)
        view.addSubview(scoreLabel)
        view.addSubview(boardView)
    }
    
    /// Enables Auto Layout for the board view.
    private func setupBoardViewProperties() {
        boardView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Sets up Auto Layout constraints for all UI elements.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currentPlayerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currentPlayerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            boardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor)
        ])
    }
    
    /// Connects board cell tap callback to viewModel with sound feedback.
    private func setupCallbacks() {
        boardView.cellTappedCallback = { [weak self] row, col in
            SoundManager.shared.play("boardTapSound")
            self?.viewModel.makeHumanMove(row: row, col: col)
        }
    }
    
    /// Adds a "Home" button to the navigation bar.
    private func setupNavigationItem() {
        let homeImage = UIImage(systemName: "house.fill")
        let homeButton = UIBarButtonItem(image: homeImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(homeButtonTapped))
        homeButton.tintColor = .playerOColor
        navigationItem.leftBarButtonItem = homeButton
    }

    // MARK: - Actions
    
    /// Plays sound and returns to the home screen.
    @objc private func homeButtonTapped() {
        SoundManager.shared.play("buttonTapSound")
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Bindings
    
    /// Connects all viewModel callback handlers to UI update methods.
    private func bindViewModel() {
        bindOnBoardChanged()
        bindOnGameEnded()
        bindOnBotMove()
    }
    
    /// Updates board cells and current player label when game state changes.
    private func bindOnBoardChanged() {
        self.viewModel.onBoardChanged = { [weak self] in
            guard let self = self else { return }
            for row in 0..<self.viewModel.board.boardSize {
                for col in 0..<self.viewModel.board.boardSize {
                    let state: State
                    switch self.viewModel.board[row, col] {
                    case .x: state = .x
                    case .o: state = .o
                    default: state = .empty
                    }
                    self.boardView.updateCell(row: row, col: col, state: state)
                }
            }
            self.updateCurrentPlayerLabel()
        }
    }
    
    /// Highlights winning line, resets game, and navigates to winner screen.
    private func bindOnGameEnded() {
        self.viewModel.onGameEnded = { [weak self] winner in
            guard let self = self else { return }
            guard let winner = winner else { return }

            self.highlightWinningLine(for: winner)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewModel.resetGame()
                self.updateScoreLabel()
                self.showWinner(winner)
            }
        }
    }
    
    /// Plays sound effect when the bot makes a move.
    private func bindOnBotMove() {
        self.viewModel.onBotMove = {
            SoundManager.shared.play("botTapSound")
        }
    }

    // MARK: - Update UI
    
    /// Updates the current player label with name and color.
    private func updateCurrentPlayerLabel() {
        let current = viewModel.currentPlayer
        currentPlayerLabel.text = "\(String.localized("move_label")) \(current.name)"
        currentPlayerLabel.textColor = current.type == .x ? .playerXColor : .playerOColor
    }
    
    /// Refreshes the score label with updated win counters.
    private func updateScoreLabel() {
        scoreLabel.text = "\(viewModel.playerX.winCounter) : \(viewModel.playerO.winCounter)"
    }

    /// Navigates to the winner screen with the victorious player.
    /// - Parameter player: The winning Player object
    private func showWinner(_ player: Player) {
        let winnerVC = ShowWinnerViewController(viewModel: viewModel, winner: player)
        navigationController?.pushViewController(winnerVC, animated: true)
    }

    /// Animates winning line cells with the winner's color.
    /// - Parameter winner: The winning Player to determine highlight color
    private func highlightWinningLine(for winner: Player) {
        guard let winningLine = viewModel.board.winningLine else { return }
        let color: UIColor = winner.type == .x ? .playerXColor : .playerOColor
        for (row, col) in winningLine {
            UIView.animate(withDuration: 0.5) {
                self.boardView.setBoardCellColor(row: row, col: col, color: color)
            }
        }
    }

    // MARK: - Create elements
    
    /// Creates a configured UILabel via the builder.
    /// - Parameters:
    ///   - text: Initial label text
    ///   - color: Text color
    ///   - fontSize: Font size
    /// - Returns: Configured UILabel instance
    private func createLabel(text: String, color: UIColor, fontSize: CGFloat) -> UILabel {
        return self.elementsBuilder.labelBuilder.createLabel(text: text, color: color, fontSize: fontSize)
    }
}
