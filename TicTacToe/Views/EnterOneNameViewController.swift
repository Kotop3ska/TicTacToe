//
//  EnterOneNameViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/10/25.
//

import UIKit

final class EnterOneNameViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    /// Label displaying the player's name
    private(set) lazy var playerLabel = createLabels(name: .localized("default_player_name"), color: .playerXColor)
    
    /// TextField for entering player's name
    private lazy var playerTextField = createTextFields(placeholder: .localized("one_player_text_field"))
    
    /// Segmented control to select X or O symbol
    private lazy var symbolSelector = createSymbolSelector()
    
    /// Segmented control to select bot difficulty
    private lazy var playButton = createPlayButton()
    
    /// Button to start the game
    private lazy var scrollView = createScrollView()
    
    /// ScrollView to allow content to move with keyboard
    private lazy var difficultySelector = createDifficultySelector()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupActions()
        setupNavigationItem()
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods

    /// Sets up UI elements and layout constraints
    private func setupUI() {
        
        playerTextField.delegate = self
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            
        ])
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [playerLabel,
                                                       playerTextField,
                                                       symbolSelector,
                                                       difficultySelector,
                                                       spacer,
                                                       playButton])
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),

            playerTextField.heightAnchor.constraint(equalToConstant: 60),
            playerTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            
            symbolSelector.heightAnchor.constraint(equalToConstant: 30),
            symbolSelector.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            
            difficultySelector.heightAnchor.constraint(equalToConstant: 30),
            difficultySelector.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            
            playButton.heightAnchor.constraint(equalToConstant: 60),
            playButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    /// Adds targets for buttons and segmented controls
    private func setupActions() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        symbolSelector.addTarget(self, action: #selector(symbolChanged(_:)), for: .valueChanged)
        difficultySelector.addTarget(self, action: #selector(difficultyChancged(_:)), for: .valueChanged)
    }
    
    /// Sets up the navigation bar item (home button)
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        playerLabel.text = updatedText.isEmpty ? .localized("default_player_name") : updatedText
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    // MARK: - Keyboard Notifications
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyBoardHeight = keyboardFrame.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Actions
    
    /// Handles play button tap, validates input, and starts the game
    @objc private func playButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let playerName = playerLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let botName = String.localized("bot_name")
        
        guard !playerName.isEmpty else {
            let alert = UIAlertController(title: .localized("alert_title_one"),
                                          message: .localized("alert_message_one"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        
        let selectedSymbol = getSelectedSymbol()
        let selectedDifficulty = getSelectedDifficulty()
            
        let gameViewModel = GameViewModel(boardSize: 3,
                                          nameX: selectedSymbol == .x ? playerName : botName,
                                          nameO: selectedSymbol == .o ? playerName : botName,
                                          vsBot: true,
                                          humanPlaysAs: selectedSymbol,
                                          botDifficulty: selectedDifficulty)
        
        let gameBoardVC = GameBoardViewController(viewModel: gameViewModel)
        navigationController?.pushViewController(gameBoardVC, animated: true)
    }
    
    /// Returns to home screen
    @objc private func homeButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// Updates label and segmented control colors when symbol selection changes
    @objc private func symbolChanged(_ sender: UISegmentedControl) {
        SoundManager.shared.play("segmentedControlSound.wav")
        if sender.selectedSegmentIndex == 0 {
            playerLabel.textColor = .playerXColor
            
            symbolSelector.selectedSegmentTintColor = .playerXColor
            symbolSelector.setTitleTextAttributes([.foregroundColor: UIColor.playerOColor], for: .normal)
            
            difficultySelector.selectedSegmentTintColor = .playerXColor
            difficultySelector.backgroundColor = .playerOColor
        } else {
            playerLabel.textColor = .playerOColor
            
            symbolSelector.selectedSegmentTintColor = .playerOColor
            symbolSelector.setTitleTextAttributes([.foregroundColor: UIColor.playerXColor], for: .normal)
            
            difficultySelector.selectedSegmentTintColor = .playerOColor
            difficultySelector.backgroundColor = .playerXColor
        }
    }
    
    /// Starts sound when difficulty selection changes
    @objc private func difficultyChancged(_ sender: UISegmentedControl) {
        SoundManager.shared.play("segmentedControlSound.wav")
    }
    
    // MARK: - Create Elements
    
    private func createLabels(name: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func createTextFields(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 30
        textField.clipsToBounds = true
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.overrideUserInterfaceStyle = .light
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }
    
    private func createPlayButton() -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .playerXColor
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        
        let attributedString = NSMutableAttributedString()

        if let playImage = UIImage(systemName: "play.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            let attachment = NSTextAttachment()
            attachment.image = playImage
            attachment.bounds = CGRect(x: 0, y: -4, width: playImage.size.width * 1.7, height: playImage.size.height * 1.7)
            attributedString.append(NSAttributedString(attachment: attachment))
        }
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }
    
    private func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    private func createSymbolSelector() -> UISegmentedControl {
        let control = UISegmentedControl(items: ["X", "O"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .playerXColor
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.playerOColor], for: .normal)
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }
    
    private func createDifficultySelector() -> UISegmentedControl {
        let control = UISegmentedControl(items: [String.localized("difficulty_selector_0"),
                                                 String.localized("difficulty_selector_1"),
                                                 String.localized("difficulty_selector_2")])
        control.selectedSegmentIndex = 1
        control.selectedSegmentTintColor = .playerXColor
        control.backgroundColor = .playerOColor
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }
    
    // MARK: - Helpers
    
    /// Returns the selected bot difficulty from the segmented control
    private func getSelectedDifficulty() -> BotPlayer.BotDifficulty {
        switch difficultySelector.selectedSegmentIndex {
        case 0: return .easy
        case 1: return .medium
        default: return .hard
        }
    }
    
    /// Returns the selected player symbol
    private func getSelectedSymbol() -> Player.PlayerType {
        return symbolSelector.selectedSegmentIndex == 0 ? .x : .o
    }
}
