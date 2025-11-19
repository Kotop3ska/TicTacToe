//
//  ShowWinnerController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/7/25.
//

import UIKit

class ShowWinnerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: GameViewModel
    private let winner: Player?
    
    private lazy var winnerLable = createWinnerLabel()
    private lazy var restartButton = createButton(name: "arrow.trianglehead.counterclockwise", color: .playerXColor)
    private lazy var goHomeButton = createButton(name: "house.fill", color: .playerOColor)
    private lazy var cupImageView = createImageView(name: "WinnerCup")
    
    // MARK: - Init
    
    init(viewModel: GameViewModel, winner: Player?) {
        self.viewModel = viewModel
        self.winner = winner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.shared.play("winSound.wav")
        animateWinnerLabel()
        animateCupPulse()
        animateBurst()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup UI
    
    /// Sets up UI elements and constraints
    private func setupUI() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [cupImageView,
                                                       winnerLable,
                                                       restartButton,
                                                       goHomeButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            cupImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            cupImageView.heightAnchor.constraint(equalTo: cupImageView.widthAnchor),
            restartButton.heightAnchor.constraint(equalToConstant: 60),
            restartButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            goHomeButton.heightAnchor.constraint(equalToConstant: 60),
            goHomeButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7)
        ])
        
        // Initial state for winner label to avoid jump during animation
        winnerLable.alpha = 0
        winnerLable.transform = CGAffineTransform(translationX: 0, y: 30)
        
        // Initial state for cup image to avoid jump during animation
        cupImageView.alpha = 0
    }
    
    // MARK: - Setup Actions

    /// Attach button actions
    private func setupActions() {
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        goHomeButton.addTarget(self, action: #selector(goHomeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions

    /// Restart the game
    @objc private func restartButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let gameBoardVC = GameBoardViewController(viewModel: self.viewModel)
        navigationController?.pushViewController(gameBoardVC, animated: true)
    }
    
    /// Go back to model selection / home
    @objc private func goHomeButtonTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let modelSelectionVC = ModelSelectionViewController()
        navigationController?.pushViewController(modelSelectionVC, animated: true)
    }
    
    // MARK: - Create UI Elements
    
    /// Create a styled UIButton with SF Symbol
    private func createButton(name: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceLeftToRight
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        
        let attributedString = NSMutableAttributedString()

        if let playImage = UIImage(systemName: name)?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            let attachment = NSTextAttachment()
            attachment.image = playImage
            attachment.bounds = CGRect(x: 0, y: -4, width: playImage.size.width * 1.7, height: playImage.size.height * 1.7)
            attributedString.append(NSAttributedString(attachment: attachment))
        }
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }
    
    /// Create a UILabel for displaying winner or draw
    private func createWinnerLabel() -> UILabel {
        let label = UILabel()
        if let winner = self.winner {
            label.text = "\(String.localized("winner_label")) \(winner.name)!"
            label.textColor = winner.type == .x ? .playerXColor : .playerOColor
        } else {
            label.text = .localized("draw_label")
            label.textColor = .black
        }
        label.font = .boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.numberOfLines = 0                
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }

    /// Create UIImageView for the cup
    private func createImageView(name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    // MARK: - Animations

    /// Animate winner label appearing with upward motion
    private func animateWinnerLabel() {
        winnerLable.transform = CGAffineTransform(translationX: 0, y: 30)
        winnerLable.alpha = 0.0

        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut) {
            self.winnerLable.transform = .identity
            self.winnerLable.alpha = 1.0
        }
    }
    
    /// Burst animation under the cup for celebration
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
    
    /// Pulse animation for the cup to emphasize celebration
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

