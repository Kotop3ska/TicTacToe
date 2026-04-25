//
//  BoardView.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit
import UIElementsFactory
import AppResources

// MARK: - BoardView

/// Represents the game board as a UIView with a grid of interactive cells.
public class BoardView: UIView {

    // MARK: - Properties
    
    /// Two-dimensional array of field cells.
    private var boardCells: [[BoardCellView]] = []
    
    /// Called when a cell is tapped and its coordinates are passed.
    public var cellTappedCallback: ((Int, Int) -> Void)?
    
    /// Defines the size of game board (N×N).
    private let boardSize: Int
    
    /// Indentation between cells.
    private let spacing: CGFloat = 5
    
    /// Radius of rounding of cell corners.
    private let cornerRadius: CGFloat = 15
    
    /// Provides access to UI component builders.
    private let elementsBuilder = UIFactory.shared

    // MARK: - Init
    
    /// Initializes a board of the specified size.
    /// - Parameter boardSize: Number of cells per side
    public init(boardSize: Int) {
        self.boardSize = boardSize
        super.init(frame: .zero)
        setupBoard()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    /// Updates the state of the specified cell.
    /// - Parameters:
    /// - row: Row index
    /// - col: Column index
    /// - state: The new state of the cell
    public func updateCell(row: Int, col: Int, state: State) {
        let cell = self.boardCells[row][col]
        if cell.state != state {
            cell.state = state
            //cell.animatePlacement()
        }
    }
    
    /// Updates background color specialized cell.
    /// - Parameters:
    ///   - row: Row index of target cell
    ///   - col: Column index of target cell
    ///   - color: Target color
    public func setBoardCellColor(row: Int, col: Int, color: UIColor) {
        guard row >= 0, row < self.boardSize, col >= 0, col < self.boardSize else { return }
        self.boardCells[row][col].backgroundColor = color
    }

    // MARK: - Setup Board
    
    /// Creates and configures the field's cell grid.
    private func setupBoard() {
        self.boardCells = []
            
        let verticalStack = createVerticalStackView()
        addSubview(verticalStack)
        setupVerticalStackConstraints(verticalStack)
            
        for _ in 0..<self.boardSize {
            let (rowStack, rowCells) = createRowStackView()
            verticalStack.addArrangedSubview(rowStack)
            self.boardCells.append(rowCells)
        }
    }
    
    /// Creates a vertical stack for the field's rows.
    /// - Returns: The configured UIStackView
    private func createVerticalStackView() -> UIStackView {
        return self.elementsBuilder.stackBuilder.createVerticalStackView(with: self.spacing, distribution: .fillEqually, alignment: .fill)
    }
    
    
    /// Anchors the vertical stack to the bounds of the viewport.
    /// - Parameter stack: Target UIStackView
    private func setupVerticalStackConstraints(_ stack: UIStackView) {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    /// Creates a horizontal stack for a single row of cells.
    /// - Returns: A tuple containing the stack and an array of created cells
    private func createRowStackView() -> (stack: UIStackView, cells: [BoardCellView]) {
        let stack = self.elementsBuilder.stackBuilder.createHorizontalStackView(with: self.spacing, distribution: .fillEqually, alignment: .fill)
        
        var rowCells: [BoardCellView] = []
        
        for _ in 0..<self.boardSize {
            let cell = createBoardCell()
            stack.addArrangedSubview(cell)
            rowCells.append(cell)
        }
        
        return (stack, rowCells)
    }
    
    /// Creates and configures a single field cell.
    /// - Returns: A configured BoardCellView with a tap handler
    private func createBoardCell() -> BoardCellView {
        let cell = BoardCellView()
        cell.backgroundColor = .black
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = self.cornerRadius
        cell.clipsToBounds = true
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }

    // MARK: - Actions
    
    /// Processes a tap on a cell and calls a callback with coordinates.
    /// - Parameter sender: UITapGestureRecognizer
    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? BoardCellView else { return }
        for (rowIndex, row) in self.boardCells.enumerated() {
            if let colIndex = row.firstIndex(of: cell) {
                self.cellTappedCallback?(rowIndex, colIndex)
                break
            }
        }
    }
    
    
}
