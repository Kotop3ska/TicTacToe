//
//  EnterNamesViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/5/25.
//

import UIKit
import UIElementsFactory
import AppResources
import GameViewModels

/// Presents the screen for entering names of two players for a local game.
final class EnterTwoNamesViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    /// Label for Player X.
    private(set) lazy var playerXLabel = createLabel(text: .localized("default_player1_name"), color: .playerXColor)
    
    /// Label for Player O.
    private(set) lazy var playerOLabel = createLabel(text: .localized("default_player2_name"), color: .playerOColor)
    
    /// TextField for entering Player X name.
    private lazy var playerXTextField = createTextFields(placeholder: .localized("player1_text_field"))
    
    /// TextField for entering Player O name.
    private lazy var playerOTextField = createTextFields(placeholder: .localized("player2_text_field"))
    
    /// Button to start the game.
    private lazy var playButton = createPlayButton()
    
    /// ScrollView to handle keyboard appearance.
    private lazy var scrollView = createScrollView()
    
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
    
    /// Configures UI elements, stack, and autolayout constraints.
    private func setupUI() {
        
        self.setupTextFieldDelegates()
        self.setupScrollView()
        
        let stackView = self.createStackView()
        self.setupStackViewConstraints(stackView: stackView)
    }
    
    /// Assigns delegates to text fields.
    private func setupTextFieldDelegates() {
        self.playerXTextField.delegate = self
        self.playerOTextField.delegate = self
    }
    
    /// Adds scroll view and pins it to safe area guides.
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    /// Creates a vertical stack view with form elements and adds it to scroll view.
    /// - Returns: Configured UIStackView
    private func createStackView() -> UIStackView {
        let spacer = self.createSpacerView()
        let stackView = self.elementsFactory.stackBuilder.createVerticalStackView(with: 30,
                                                                                  distribution: .fill,
                                                                                  alignment: .center)
        stackView.addArrangedSubview(self.playerXLabel)
        stackView.addArrangedSubview(self.playerXTextField)
        stackView.addArrangedSubview(self.playerOLabel)
        stackView.addArrangedSubview(self.playerOTextField)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(self.playButton)
        
        self.scrollView.addSubview(stackView)
        return stackView
    }
    
    /// Creates an invisible spacer view with fixed height.
    /// - Returns: UIView with 60pt height constraint
    private func createSpacerView() -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return spacer
    }
    
    /// Sets up constraints for the form stack view.
    /// - Parameter stackView: Target UIStackView
    private func setupStackViewConstraints(stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 40),
            stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.9),
            
            self.playerXTextField.heightAnchor.constraint(equalToConstant: 60),
            self.playerXTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            self.playerOTextField.heightAnchor.constraint(equalToConstant: 60),
            self.playerOTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),

            self.playButton.heightAnchor.constraint(equalToConstant: 60),
            self.playButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    /// Connects tap handler to the play button.
    private func setupActions() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
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
    
    // MARK: - UITextFieldDelegate
    
    /// Updates the corresponding label as text field content changes.
    /// - Returns: `true` to allow text change
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        if textField == playerXTextField {
            playerXLabel.text = updatedText.isEmpty ? .localized("player1_text_field") : updatedText
        } else {
            playerOLabel.text = updatedText.isEmpty ? .localized("player2_text_field") : updatedText
        }
        return true
    }
    
    /// Moves to next field or resigns keyboard on Return key.
    /// - Returns: `true` to handle the event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == playerXTextField {
            playerOTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Keyboard notifications
    
    /// Adjusts scroll view inset when keyboard appears.
    /// - Parameter notification: Notification containing keyboard frame
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyBoardHeight = keyboardFrame.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    /// Resets scroll view insets when keyboard hides.
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Button actions

    /// Validates player names and navigates to the game screen.
    @objc private func playButtonTapped() {
        SoundManager.shared.play("buttonTapSound")
        guard let (playerXName, playerOName) = self.validatePlayerNames() else { return }
            
        let viewModel = createGameViewModel(playerXName: playerXName, playerOName: playerOName)
        navigateToGame(viewModel: viewModel)
    }
    
    /// Validates that both names are non-empty; shows alert on error.
    /// - Returns: Tuple of names or `nil` if validation fails
    private func validatePlayerNames() -> (String, String)? {
        let playerXName = self.playerXLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let playerOName = self.playerOLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !playerXName.isEmpty, !playerOName.isEmpty else {
            showEmptyNamesAlert()
            return nil
        }
        
        return (playerXName, playerOName)
    }
    
    /// Shows an alert when one or both names are empty.
    private func showEmptyNamesAlert() {
        let alert = UIAlertController(title: .localized("alert_title_two"),
                                      message: .localized("alert_message_two"),
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    /// Creates a GameViewModel for a two-player game.
    /// - Parameters:
    ///   - playerXName: Name for Player X
    ///   - playerOName: Name for Player O
    /// - Returns: Configured GameViewModel instance
    private func createGameViewModel(playerXName: String, playerOName: String) -> GameViewModel {
        return GameViewModel(boardSize: 3, nameX: playerXName, nameO: playerOName)
    }
    
    /// Navigates to the game board screen with the provided view model.
    /// - Parameter viewModel: GameViewModel instance
    private func navigateToGame(viewModel: GameViewModel) {
        let gameBoardVC = GameBoardViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(gameBoardVC, animated: true)
    }
    
    /// Returns to the home screen.
    @objc private func homeButtonTapped() {
        SoundManager.shared.play("buttonTapSound")
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Create elements
    
    /// Creates a UILabel via the builder.
    /// - Parameters:
    ///   - text: Label text
    ///   - color: Text color
    /// - Returns: Configured UILabel
    private func createLabel(text: String, color: UIColor) -> UILabel {
        return self.elementsFactory.labelBuilder.createLabel(text: text, color: color, fontSize: 24)
    }
    
    /// Creates a UITextField via the builder.
    /// - Parameter placeholder: Placeholder text
    /// - Returns: Configured UITextField
    private func createTextFields(placeholder: String) -> UITextField {
        return self.elementsFactory.textFieldBuilder.createTextField(placeholder: placeholder, borderColor: .gray, borderWidth: 0.5, cornerRadius: 15, backgroundColor: .white, textColor: .black)
    }
    
    /// Creates a UIButton with a play icon via the builder.
    /// - Returns: Configured UIButton with play.fill icon
    private func createPlayButton() -> UIButton {
       return self.elementsFactory.buttonBuilder.createButton(withIcon: "play.fill", color: .playerXColor, cornerRadius: 15, fontSize: 24)
    }
    
    /// Creates a UIScrollView via the builder.
    /// - Returns: Configured UIScrollView
    private func createScrollView() -> UIScrollView {
        return self.elementsFactory.scrollViewBuilder.createScrollView()
    }
}
