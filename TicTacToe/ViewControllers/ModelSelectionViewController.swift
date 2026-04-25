//
//  ModelSelectionViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/4/25.
//

import UIKit
import UIElementsFactory
import AppResources

/// Presents the main menu for selecting game mode (1-player vs bot or 2-player local).
final class ModelSelectionViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Button to start a single-player game against the bot.
    private lazy var onePlayerButton = createButton(leftIcon: "gamecontroller.fill", rightIcon: "person.fill")
    
    /// Button to start a two-player local game.
    private lazy var twoPlayerButton = createButton(leftIcon: "person.fill", rightIcon: "person.fill")
    
    /// The main logo image.
    private lazy var iconImageView = createImageView(name: "MainLogo")
    
    /// Provides access to UI component factory.
    private let elementsFactory = UIFactory.shared
    
    // MARK: - Life cycle
    
    /// Configures the UI, hides back button, and sets up navigation.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        setupUI()
        setupActions()
        setupNavigationItem()
        
    }
    
   // MARK: - Setup methods
    
    /// Creates and configures the main vertical stack view with constraints.
    private func setupUI() {
        let stackView = self.createStackView()
        self.view.addSubview(stackView)
        self.setupStackViewConstraints(stackView: stackView)
        
    }
    
    /// Builds a vertical stack view containing logo and mode selection buttons.
    /// - Returns: Configured UIStackView with centered alignment
    private func createStackView() -> UIStackView {
        let stackView = self.elementsFactory.stackBuilder.createVerticalStackView(with: 30,
                                                                                  distribution: .fill,
                                                                                  alignment: .center)
        stackView.addArrangedSubview(self.iconImageView)
        stackView.addArrangedSubview(self.onePlayerButton)
        stackView.addArrangedSubview(self.twoPlayerButton)

        return stackView
    }
    
    /// Sets up Auto Layout constraints for the stack view and its subviews.
    /// - Parameter stackView: Target UIStackView to constrain
    private func setupStackViewConstraints(stackView: UIStackView) {
        let centerYConstraint = self.createStackViewCenterYConstraint(stackView: stackView)
        
        NSLayoutConstraint.activate([
            // StackView positioning
            stackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            centerYConstraint,
            
            // Icon constraints
            self.iconImageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            self.iconImageView.heightAnchor.constraint(equalTo: self.iconImageView.widthAnchor),
            
            // One Player Button constraints
            self.onePlayerButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            self.onePlayerButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Two Players Button constraints
            self.twoPlayerButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            self.twoPlayerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    /// Creates a low-priority centerY constraint for flexible vertical positioning.
    /// - Parameter stackView: Target UIStackView
    /// - Returns: NSLayoutConstraint with .defaultLow priority
    private func createStackViewCenterYConstraint(stackView: UIStackView) -> NSLayoutConstraint {
        let centerY = stackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        centerY.priority = .defaultLow
        return centerY
    }
    
    /// Adds a settings button to the right side of the navigation bar.
    private func setupNavigationItem() {
        let settingsImage = UIImage(systemName: "gearshape.fill")
        let settingsButton = UIBarButtonItem(image: settingsImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsTapped))
        settingsButton.tintColor = .black
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    /// Connects tap actions to the game mode selection buttons.
    private func setupActions() {
        onePlayerButton.addTarget(self, action: #selector(onePlayerTapped), for: .touchUpInside)
        twoPlayerButton.addTarget(self, action: #selector(twoPlayerTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    /// Plays sound and navigates to the single-player name entry screen.
    @objc private func onePlayerTapped() {
        SoundManager.shared.play("buttonTapSound")
        let enterNamesVC = EnterOneNameViewController()
        navigationController?.pushViewController(enterNamesVC, animated: true)
    }
    
    /// Plays sound and navigates to the two-player name entry screen.
    @objc private func twoPlayerTapped() {
        SoundManager.shared.play("buttonTapSound")
        let enterNamesVC = EnterTwoNamesViewController()
        navigationController?.pushViewController(enterNamesVC, animated: true)
    }
    
    /// Plays sound and presents the settings screen modally.
    @objc private func settingsTapped() {
        SoundManager.shared.play("buttonTapSound")
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .overCurrentContext
        settingsVC.modalTransitionStyle = .crossDissolve
        present(settingsVC, animated: true)
    }
    
    // MARK: - Create elements
    
    /// Creates a UIButton with left and right SF Symbol icons and centered text.
    /// - Parameters:
    ///   - leftIcon: SF Symbol name for the left icon
    ///   - rightIcon: SF Symbol name for the right icon
    ///   - text: Centered text between icons (default: "VS")
    /// - Returns: Configured UIButton with attributed title
    private func createButton(leftIcon: String, rightIcon: String, text: String = "VS") -> UIButton {
        
        let attachment = makeAttachment(leftIcon: leftIcon, rightIcon: rightIcon)
        return self.elementsFactory.buttonBuilder.createButton(withAttacment: attachment,
                                                                     color: .playerOColor,
                                                                     cornerRadius: 15,
                                                                     fontSize: 25)
    }
    
    /// Builds an attributed string with two icons and centered text.
    /// - Parameters:
    ///   - leftIcon: SF Symbol name for the left icon
    ///   - rightIcon: SF Symbol name for the right icon
    ///   - text: Centered text between icons (default: "VS")
    /// - Returns: NSMutableAttributedString with icon-text-icon l
    private func makeAttachment(leftIcon: String, rightIcon: String, text: String = "VS") -> NSMutableAttributedString {
        let attachment = NSMutableAttributedString()
        
        let leftIcon = UIImage(systemName: leftIcon)
        attachment.append(self.elementsFactory.buttonBuilder.makeAttachment(image: leftIcon,
                                                                            scale: 1.7,
                                                                            offset: -4,
                                                                            tintColor: .white))
        attachment.append(self.elementsFactory.buttonBuilder.makeAttachment(title: "    \(text)    "))
        let rightIcon = UIImage(systemName: rightIcon)
        attachment.append(self.elementsFactory.buttonBuilder.makeAttachment(image: rightIcon,
                                                                            scale: 1.7,
                                                                            offset: -4,
                                                                            tintColor: .white))
        
        return attachment
    }
    
    /// Creates a UIImageView with the specified image name via builder.
    /// - Parameter name: Image name in asset catalog
    /// - Returns: Configured UIImageView with aspect-fit content mode
    private func createImageView(name: String) -> UIImageView {
        return self.elementsFactory.imageViewBuilder.createImageView(name: name)
    }
    
}
