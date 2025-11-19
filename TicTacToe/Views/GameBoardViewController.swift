//
//  GameBoardViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/5/25.
//

import UIKit

// MARK: - BoardCellView
/// Custom UIView representing a single cell on the board
class BoardCellView: UIView {

    // MARK: - Constants
    private let lineInset: CGFloat = 10
    private let lineWidth: CGFloat = 8

    // MARK: - Properties
    /// State of the cell: empty, X or O
    var state: State = .empty {
        didSet { setNeedsDisplay() }
    }

    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineWidth(lineWidth)

        switch state {
        case .x:
            context.setStrokeColor(UIColor.playerXColor.cgColor)
            context.move(to: CGPoint(x: lineInset, y: lineInset))
            context.addLine(to: CGPoint(x: rect.width - lineInset, y: rect.height - lineInset))
            context.move(to: CGPoint(x: rect.width - lineInset, y: lineInset))
            context.addLine(to: CGPoint(x: lineInset, y: rect.height - lineInset))
            context.strokePath()
        case .o:
            context.setStrokeColor(UIColor.playerOColor.cgColor)
            let insetRect = rect.insetBy(dx: lineInset, dy: lineInset)
            context.strokeEllipse(in: insetRect)
        case .empty:
            break
        }
    }

    // MARK: - Animation
    func animatePlacement() {
        self.alpha = 0
        UIView.animate(withDuration: 0.3) { self.alpha = 1.0 }
    }
}

// MARK: - BoardCellView State
extension BoardCellView {
    enum State {
        case empty, x, o
    }
}

// MARK: - BoardView
/// Custom UIView representing the entire game board
class BoardView: UIView {

    // MARK: - Properties
    private(set) var boardCells: [[BoardCellView]] = []
    var cellTappedCallback: ((Int, Int) -> Void)?
    private let boardSize: Int
    private let spacing: CGFloat = 5
    private let cornerRadius: CGFloat = 15

    // MARK: - Init
    init(boardSize: Int) {
        self.boardSize = boardSize
        super.init(frame: .zero)
        setupBoard()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Board
    private func setupBoard() {
        boardCells = []

        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = spacing
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStack)

        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        for _ in 0..<boardSize {
            var rowCells: [BoardCellView] = []
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = spacing
            verticalStack.addArrangedSubview(rowStack)

            for _ in 0..<boardSize {
                let cell = BoardCellView()
                cell.backgroundColor = .black
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 2
                cell.layer.cornerRadius = cornerRadius
                cell.clipsToBounds = true
                cell.translatesAutoresizingMaskIntoConstraints = false
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cell.addGestureRecognizer(tapGesture)
                rowStack.addArrangedSubview(cell)
                rowCells.append(cell)
            }

            boardCells.append(rowCells)
        }
    }

    // MARK: - Actions
    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? BoardCellView else { return }
        for (rowIndex, row) in boardCells.enumerated() {
            if let colIndex = row.firstIndex(of: cell) {
                cellTappedCallback?(rowIndex, colIndex)
                break
            }
        }
    }

    // MARK: - Helpers
    func updateCell(row: Int, col: Int, state: BoardCellView.State) {
        let cell = boardCells[row][col]
        if cell.state != state {
            cell.state = state
            //cell.animatePlacement()
        }
    }
}

// MARK: - GameBoardViewController
/// Controller displaying the game board
final class GameBoardViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: GameViewModel
    private(set) lazy var boardView = BoardView(boardSize: viewModel.board.boardSize)
    private(set) lazy var currentPlayerLabel = createCurrentPlayerLabel()
    private(set) lazy var scoreLabel = createScoreLabel()

    // MARK: - Init
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        updateCurrentPlayerLabel()
        setupNavigationItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startGameIfBotFirst()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(currentPlayerLabel)
        view.addSubview(scoreLabel)
        view.addSubview(boardView)
        boardView.translatesAutoresizingMaskIntoConstraints = false

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

        /// Called when user taps a cell on the board (row, col)
        boardView.cellTappedCallback = { [weak self] row, col in
            SoundManager.shared.play("boardTapSound.wav")
            self?.viewModel.makeHumanMove(row: row, col: col)
        }
    }

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
    @objc private func homeButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.onBoardChanged = { [weak self] in
            guard let self = self else { return }
            for row in 0..<self.viewModel.board.boardSize {
                for col in 0..<self.viewModel.board.boardSize {
                    let state: BoardCellView.State
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

        viewModel.onGameEnded = { [weak self] winner in
            guard let self = self else { return }
            guard let winner = winner else { return }

            self.highlightWinningLine(for: winner)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewModel.resetGame()
                self.updateScoreLabel()
                self.showWinner(winner)
            }
        }
        
        viewModel.onBotMove = {
            SoundManager.shared.play("botTapSound.wav")
        }
    }

    // MARK: - Update UI
    
    /// Updates label showing which player's turn it is
    private func updateCurrentPlayerLabel() {
        let current = viewModel.currentPlayer
        currentPlayerLabel.text = "\(String.localized("move_label")) \(current.name)"
        currentPlayerLabel.textColor = current.type == .x ? .playerXColor : .playerOColor
    }

    private func updateScoreLabel() {
        scoreLabel.text = "\(viewModel.playerX.winCounter) : \(viewModel.playerO.winCounter)"
    }

    private func showWinner(_ player: Player) {
        let winnerVC = ShowWinnerViewController(viewModel: viewModel, winner: player)
        navigationController?.pushViewController(winnerVC, animated: true)
    }

    /// Animates the winning line cells based on coordinates provided by the board
    private func highlightWinningLine(for winner: Player) {
        guard let winningLine = viewModel.board.winningLine else { return }
        let color: UIColor = winner.type == .x ? .playerXColor : .playerOColor
        for (row, col) in winningLine {
            UIView.animate(withDuration: 0.5) {
                self.boardView.boardCells[row][col].backgroundColor = color
            }
        }
    }

    // MARK: - Create Elements
    private func createCurrentPlayerLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createScoreLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "\(viewModel.playerX.winCounter) : \(viewModel.playerO.winCounter)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
