//
//  EnterNamesViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/5/25.
//

import UIKit

final class EnterTwoNamesViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    /// Label for Player X
    private(set) lazy var playerXLabel = createLabels(name: .localized("default_player1_name"), color: .playerXColor)
    
    /// Label for Player O
    private(set) lazy var playerOLabel = createLabels(name: .localized("default_player2_name"), color: .playerOColor)
    
    /// TextField for entering Player X name
    private lazy var playerXTextField = createTextFields(placeholder: .localized("player1_text_field"))
    
    /// TextField for entering Player O name
    private lazy var playerOTextField = createTextFields(placeholder: .localized("player2_text_field"))
    
    /// Button to start the game
    private lazy var playButton = createPlayButton()
    
    /// ScrollView to handle keyboard appearance
    private lazy var scrollView = createScrollView()
  
    // MARK: - Life cycle
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
    
    /// Sets up UI elements, StackView, and constraints
    private func setupUI() {
        
        playerXTextField.delegate = self
        playerOTextField.delegate = self
        
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
        
        let stackView = UIStackView(arrangedSubviews: [playerXLabel,
                                                       playerXTextField,
                                                       playerOLabel,
                                                       playerOTextField,
                                                       spacer,
                                                       playButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),

            playerXTextField.heightAnchor.constraint(equalToConstant: 60),
            playerXTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            playerOTextField.heightAnchor.constraint(equalToConstant: 60),
            playerOTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            playButton.heightAnchor.constraint(equalToConstant: 60),
            playButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    /// Adds button targets
    private func setupActions() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    /// Sets up the navigation bar home button
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
    
    /// Updates player labels as text fields change
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
    
    /// Moves to next field or resigns keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == playerXTextField {
            playerOTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Keyboard Notifications
    
    /// Adjusts scrollView when keyboard appears
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyBoardHeight = keyboardFrame.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    /// Resets scrollView when keyboard hides
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Button Actions

    /// Validates input and starts 2-player game
    @objc private func playButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let playerXName = playerXLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let playerOName = playerOLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !playerXName.isEmpty, !playerOName.isEmpty else {
            let alert = UIAlertController(title: .localized("alert_title_two"),
                                          message: .localized("alert_message_two"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
        
        let gameViewModel = GameViewModel(boardSize: 3, nameX: playerXName, nameO: playerOName)
        
        let gameBoardVC = GameBoardViewController(viewModel: gameViewModel)
        navigationController?.pushViewController(gameBoardVC, animated: true)
    }
    
    /// Navigates back to home
    @objc private func homeButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        navigationController?.popToRootViewController(animated: true)
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
}
