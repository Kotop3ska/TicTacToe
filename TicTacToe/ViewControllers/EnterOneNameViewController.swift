//
//  EnterOneNameViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/10/25.
//

import UIKit
import UIElementsFactory
import AppResources
import GameModels
import GameViewModels

/// Represents the player name input screen for a game against a bot.
final class EnterOneNameViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    /// Label displaying the player's name.
    private(set) lazy var playerLabel = createLabels(text: .localized("default_player_name"), color: .playerXColor)
    
    /// TextField for entering player's name.
    private lazy var playerTextField = createTextFields(placeholder: .localized("one_player_text_field"))
    
    /// Segmented control to select X or O symbol.
    private lazy var symbolSelector = createSegmentedControl(items: ["X", "O"],
                                                             selectedTextColor: .white,
                                                             normalTextColor: .playerXColor)
    
    /// Segmented control to select bot difficulty.
    private lazy var playButton = createPlayButton(iconName: "play.fill", color: .playerXColor)
    
    /// Button to start the game.
    private lazy var scrollView = createScrollView()
    
    /// ScrollView to allow content to move with keyboard.
    private lazy var difficultySelector = createSegmentedControl(items: [String.localized("difficulty_selector_0"),
                                                                         String.localized("difficulty_selector_1"),
                                                                         String.localized("difficulty_selector_2")],
                                                                 backgroundColor: .playerOColor,
                                                                 selectedTextColor: .white,
                                                                 normalTextColor: .white)
    /// Provides access to UI component factory.
    private let elementsFactory = UIFactory.shared
    
    // MARK: - Life cycle
    
    /// Initializes the interface and connects event handlers.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupActions()
        setupNavigationItem()
    }
    
    /// Subscribes to notifications about showing/hiding the keyboard.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    /// Unsubscribes from notifications when the screen is hidden.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup methods

    /// Sets up UI elements and layout constraints.
    private func setupUI() {
        configureDelegates()
        addSubviews()
        setupScrollViewConstraints()
        let spacer = createSpacer()
        let stackView = createStackView(with: spacer)
        setupStackViewConstraints(for: stackView)
    }
    
    /// Assigns a delegate to the text field.
    private func configureDelegates() {
        self.playerTextField.delegate = self
    }
    
    /// Adds a scroll view to the view hierarchy.
    private func addSubviews() {
        view.addSubview(self.scrollView)
    }
    
    /// Binds the scroll view to safe areas of the screen.
    private func setupScrollViewConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    /// Creates a vertical stack of form elements and adds it to the scroll view.
    /// - Parameter spacer: Spacer for indentation
    /// - Returns: The configured UIStackView
    private func createStackView(with spacer: UIView) -> UIStackView {
        let stackView = self.elementsFactory.stackBuilder.createVerticalStackView(with: 50,
                                                                                  distribution: .fill,
                                                                                  alignment: .center)
        stackView.addArrangedSubview(self.playerLabel)
        stackView.addArrangedSubview(self.playerTextField)
        stackView.addArrangedSubview(self.symbolSelector)
        stackView.addArrangedSubview(self.difficultySelector)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(self.playButton)
        
        self.scrollView.addSubview(stackView)
        
        return stackView
    }
    
    /// Creates an invisible divider with a fixed height.
    /// - Returns: A UIView with a height constraint of 60pt
    private func createSpacer() -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return spacer
    }
    
    /// Configures constraints for the form element stack.
    /// - Parameter stackView: Target UIStackView
    private func setupStackViewConstraints(for stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 40),
            stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.9),
            
            self.playerTextField.heightAnchor.constraint(equalToConstant: 60),
            self.playerTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            
            self.symbolSelector.heightAnchor.constraint(equalToConstant: 30),
            self.symbolSelector.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            
            self.difficultySelector.heightAnchor.constraint(equalToConstant: 30),
            self.difficultySelector.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            
            self.playButton.heightAnchor.constraint(equalToConstant: 60),
            self.playButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    /// Attaches event handlers for interactive elements.
    private func setupActions() {
        self.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        self.symbolSelector.addTarget(self, action: #selector(symbolChanged(_:)), for: .valueChanged)
        self.difficultySelector.addTarget(self, action: #selector(difficultyChancged(_:)), for: .valueChanged)
    }
    
    /// Sets up the navigation bar item (home button).
    private func setupNavigationItem() {
        let homeImage = UIImage(systemName: "house.fill")
        let homeButton = UIBarButtonItem(image: homeImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(homeButtonTapped))
        homeButton.tintColor = .playerOColor
        navigationItem.leftBarButtonItem = homeButton
        
    }
    
    // MARK: - UITextFieldDelegate
    
    /// Updates the name label when text is entered into the field.
    /// - Returns: `true` to allow text changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        self.playerLabel.text = updatedText.isEmpty ? .localized("default_player_name") : updatedText
        return true
    }
    
    /// Hides the keyboard when Return is pressed.
    /// - Returns: `true` to handle the event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    // MARK: - Keyboard notifications
    
    /// Adjusts the scroll offset when the keyboard appears.
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyBoardHeight = keyboardFrame.height
        
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardHeight, right: 0)
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
    
    /// Resets scroll view insets when keyboard hides.
    @objc private func keyboardWillHide(notification: Notification) {
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Actions
    
    /// Handles play button tap, validates input, and starts the game.
    @objc private func playButtonTapped() {
        SoundManager.shared.play("buttonTapSound")
        guard let playerName = self.validatePlayerName() else { return }
        
        let viewModel = self.createGameViewModel(playerName: playerName)
        self.navigateToGame(viewModel: viewModel)
    }
    
    /// Validates the player's name and displays an alert if an error occurs.
    /// - Returns: The cleared name, or `nil` if the input is empty.
    private func validatePlayerName() -> String? {
        let name = self.playerLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !name.isEmpty else {
            showEmptyNameAlert()
            return nil
        }
        
        return name
    }
    
    /// Shows an alert with an empty name error message.
    private func showEmptyNameAlert() {
        let alert = UIAlertController(title: .localized("alert_title_one"),
                                      message: .localized("alert_message_one"),
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    /// Creates a GameViewModel with the selected game settings.
    /// - Parameter playerName: Player name
    /// - Returns: The configured GameViewModel instance
    private func createGameViewModel(playerName: String) -> GameViewModel {
        let botName = String.localized("bot_name")
        let selectedSymbol = getSelectedSymbol()
        let selectedDifficulty = getSelectedDifficulty()
        
        return GameViewModel(boardSize: 3,
                             nameX: selectedSymbol == .x ? playerName : botName,
                             nameO: selectedSymbol == .o ? playerName : botName,
                             vsBot: true,
                             humanPlaysAs: selectedSymbol,
                             botDifficulty: selectedDifficulty)
    }
    
    /// Navigates to the game screen with the passed model.
    /// - Parameter viewModel: GameViewModel instance
    private func navigateToGame(viewModel: GameViewModel) {
        let gameBoardVC = GameBoardViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(gameBoardVC, animated: true)
    }
    
    /// Returns to home screen.
    @objc private func homeButtonTapped() {
        SoundManager.shared.play("buttonTapSound")
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// Updates label and segmented control colors when symbol selection changes.
    @objc private func symbolChanged(_ sender: UISegmentedControl) {
        SoundManager.shared.play("segmentedControlSound")
        if sender.selectedSegmentIndex == 0 {
            self.playerLabel.textColor = .playerXColor
            
            self.symbolSelector.selectedSegmentTintColor = .playerXColor
            self.symbolSelector.setTitleTextAttributes([.foregroundColor: UIColor.playerOColor], for: .normal)
            
            self.difficultySelector.selectedSegmentTintColor = .playerXColor
            self.difficultySelector.backgroundColor = .playerOColor
        } else {
            self.playerLabel.textColor = .playerOColor
            
            self.symbolSelector.selectedSegmentTintColor = .playerOColor
            self.symbolSelector.setTitleTextAttributes([.foregroundColor: UIColor.playerXColor], for: .normal)
            
            self.difficultySelector.selectedSegmentTintColor = .playerOColor
            self.difficultySelector.backgroundColor = .playerXColor
        }
    }
    
    /// Starts sound when difficulty selection changes.
    @objc private func difficultyChancged(_ sender: UISegmentedControl) {
        SoundManager.shared.play("segmentedControlSound")
    }
    
    // MARK: - Create elements
    
    private func createLabels(text: String, color: UIColor) -> UILabel {
        return self.elementsFactory.labelBuilder.createLabel(text: text, color: color, fontSize: 24)
    }
    
    private func createTextFields(placeholder: String) -> UITextField {
        return self.elementsFactory.textFieldBuilder.createTextField(placeholder: placeholder,
                                                                     borderColor: .gray,
                                                                     borderWidth: 0.5,
                                                                     cornerRadius: 15,
                                                                     backgroundColor: .white,
                                                                     textColor: .black
        )
    }
    
    private func createPlayButton(iconName: String, color: UIColor) -> UIButton {
        return self.elementsFactory.buttonBuilder.createButton(withIcon: iconName,
                                                               color: color,
                                                               cornerRadius: 15,
                                                               fontSize: 24)
    }
    
    private func createScrollView() -> UIScrollView {
        return self.elementsFactory.scrollViewBuilder.createScrollView()
    }
    
    private func createSegmentedControl(items: [String],
                                        backgroundColor: UIColor? = nil,
                                        selectedTextColor: UIColor,
                                        normalTextColor: UIColor) -> UISegmentedControl {
        
        return self.elementsFactory.segmentedControlBuilder
            .createSegmentedControl(items: items,
                                    selectedIndex: 0,
                                    selectedTintColor: .playerXColor,
                                    backgroundColor: backgroundColor,
                                    selectedTextColor: selectedTextColor,
                                    normalTextColor: normalTextColor)
    }
    
    // MARK: - Helpers
    
    /// Returns the selected bot difficulty level.
    /// - Returns: Difficulty value (.easy/.medium/.hard)
    private func getSelectedDifficulty() -> Difficulty {
        switch self.difficultySelector.selectedSegmentIndex {
        case 0: return .easy
        case 1: return .medium
        default: return .hard
        }
    }
    
    /// Returns the selected player piece.
    /// - Returns: Player.PlayerType (.x or .o)
    private func getSelectedSymbol() -> Player.PlayerType {
        return self.symbolSelector.selectedSegmentIndex == 0 ? .x : .o
    }
}
