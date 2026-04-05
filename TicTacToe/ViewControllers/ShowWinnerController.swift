//
//  ShowWinnerController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/7/25.
//

import UIKit
import UIElementsBuilders
import AppResources
import GameModels
import GameViewModels

/// Displays the game result screen with winner announcement and celebration animations.
class ShowWinnerViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The game view model for restarting or continuing gameplay.
    private let viewModel: GameViewModel
    
    /// Stores the winning player or nil for a draw.
    private let winner: Player?
    
    /// Displays the winner name or draw message with animated entrance.
    private lazy var winnerLable = createWinnerLabel()
    
    /// Button to restart the current game session.
    private lazy var restartButton = createButton(iconName: "arrow.trianglehead.counterclockwise", color: .playerXColor)
    
    /// Button to return to the main menu.
    private lazy var goHomeButton = createButton(iconName: "house.fill", color: .playerOColor)
   
    /// The winner cup image.
    private lazy var cupImageView = createImageView(name: "WinnerCup")
    
    /// Provides access to UI component builders.
    private let elementsBuilder = UIBuilder.shared
    
    // MARK: - Init
    
    /// Initializes the winner screen with game data.
    /// - Parameters:
    ///   - viewModel: GameViewModel for game continuation
    ///   - winner: Winning Player or nil for draw
    init(viewModel: GameViewModel, winner: Player?) {
        self.viewModel = viewModel
        self.winner = winner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    /// Configures UI elements and connects button actions.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    /// Hides the navigation bar for full-screen celebration view.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /// Plays win sound and triggers celebration animations.
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.shared.play("winSound")
        animateWinnerLabel()
        animateCupPulse()
        animateBurst()
    }

    /// Restores the navigation bar when leaving the screen.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup UI
    
    /// Configures background, stack view, constraints, and initial animation states.
    private func setupUI() {
        self.setupBackground()
            
        let stackView = self.createStackView()
        self.view.addSubview(stackView)
        self.setupStackViewConstraints(stackView: stackView)
        self.setupInitialAnimationStates()
    }
    
    /// Sets the view background to white.
    private func setupBackground() {
        self.view.backgroundColor = .white
    }
    
    /// Creates a vertical stack view with cup, label, and action buttons.
    /// - Returns: Configured UIStackView with centered alignment
    private func createStackView() -> UIStackView {
        let stackView = self.elementsBuilder.stackBuilder.createVerticalStackView(with: 30,
                                                                                  distribution: .fill,
                                                                                  alignment: .center)
        stackView.addArrangedSubview(self.cupImageView)
        stackView.addArrangedSubview(self.winnerLable)
        stackView.addArrangedSubview(self.restartButton)
        stackView.addArrangedSubview(self.goHomeButton)
        
        return stackView
    }
    
    /// Sets up Auto Layout constraints for the stack view and its subviews.
    /// - Parameter stackView: Target UIStackView to constrain
    private func setupStackViewConstraints(stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            
            self.cupImageView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            self.cupImageView.heightAnchor.constraint(equalTo: self.cupImageView.widthAnchor),
            
            self.restartButton.heightAnchor.constraint(equalToConstant: 60),
            self.restartButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            
            self.goHomeButton.heightAnchor.constraint(equalToConstant: 60),
            self.goHomeButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    /// Sets initial hidden/offset states for animated elements.
    private func setupInitialAnimationStates() {
        self.winnerLable.alpha = 0
        self.winnerLable.transform = CGAffineTransform(translationX: 0, y: 30)
        
        self.cupImageView.alpha = 0
    }
    
    // MARK: - Setup actions

    /// Connects touch actions to restart and home buttons.
    private func setupActions() {
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        goHomeButton.addTarget(self, action: #selector(goHomeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button actions

    /// Plays sound and restarts the game with the same view model.
    @objc private func restartButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let gameBoardVC = GameBoardViewController(viewModel: self.viewModel)
        navigationController?.pushViewController(gameBoardVC, animated: true)
    }
    
    /// Plays sound and returns to the main menu screen.
    @objc private func goHomeButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let modelSelectionVC = ModelSelectionViewController()
        navigationController?.pushViewController(modelSelectionVC, animated: true)
    }
    
    // MARK: - Create UI elements
    
    /// Creates a styled UIButton with an SF Symbol icon.
    /// - Parameters:
    ///   - iconName: SF Symbol name for the button icon
    ///   - color: Background color for the button
    /// - Returns: Configured UIButton instance
    private func createButton(iconName: String, color: UIColor) -> UIButton {
        return self.elementsBuilder.buttonBuilder.createButton(withIcon: iconName, color: color, cornerRadius: 15, fontSize: 24)
    }
    
    /// Creates a UILabel displaying the winner name or draw message.
    /// - Returns: Configured UILabel with appropriate text and color
    private func createWinnerLabel() -> UILabel {
        guard let winner = self.winner else {
            let text = String.localized("draw_label")
            let textColor = UIColor.black
            return self.elementsBuilder.labelBuilder.createLabel(text: text, color: textColor, fontSize: 40)
        }
        let text = "\(String.localized("winner_label")) \(winner.name)!"
        let textColor = winner.type == .x ? UIColor.playerXColor : UIColor.playerOColor

        return self.elementsBuilder.labelBuilder.createLabel(text: text, color: textColor, fontSize: 40)
    }

    /// Creates a UIImageView with the specified image name.
    /// - Parameter name: Image name in asset catalog
    /// - Returns: Configured UIImageView instance
    private func createImageView(name: String) -> UIImageView {
        return self.elementsBuilder.imageViewBuilder.createImageView(name: name)
    }
    
    // MARK: - Animations

    /// Animates the winner label sliding up and fading in.
    private func animateWinnerLabel() {
        winnerLable.transform = CGAffineTransform(translationX: 0, y: 30)
        winnerLable.alpha = 0.0

        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut) {
            self.winnerLable.transform = .identity
            self.winnerLable.alpha = 1.0
        }
    }
    
    /// Creates a radial burst animation behind the cup for celebration effect.
    private func animateBurst() {
        let burst = CALayer()
        
        let position = cupImageView.superview?.convert(cupImageView.center, to: view) ?? cupImageView.center
        burst.position = position
        
        burst.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        burst.cornerRadius = 50
        burst.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.5).cgColor
        
        view.layer.insertSublayer(burst, below: cupImageView.layer)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.3
        scale.toValue = 8.0

        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.8
        fade.toValue = 0.0

        let group = CAAnimationGroup()
        group.animations = [scale, fade]
        group.duration = 1.4
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false

        burst.add(group, forKey: "burst")
    }
    
    /// Applies a subtle pulse scale animation to the cup image.
    private func animateCupPulse() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.cupImageView.alpha = 1.0
        }
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.duration = 0.6
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        cupImageView.layer.add(pulse, forKey: "pulse")
    }
}

