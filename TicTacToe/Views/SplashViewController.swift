//
//  SplashViewControllerViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/5/25.
//

import UIKit

/// Initial launch screen that shows the logo animation before transitioning
/// to the main model selection screen.
class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LoadLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
    }
    
    // MARK: - UI Setup
    
    /// Configures layout and appearance of the splash screen.
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Main Methods
    
    /// Performs scale + fade-in animation on the logo.
    /// After the animation completes, the controller transitions to the main screen.
    private func animateLogo() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        logoImageView.alpha = 0.0
        DispatchQueue.main.async {
            SoundManager.shared.play("startGameSound.wav")
        }
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseOut) {
            self.logoImageView.transform = .identity
            self.logoImageView.alpha = 1.0
        } completion: { _ in
            self.goToMainScreen()
        }
    }
    
    /// Opens the model selection screen inside a navigation controller.
    private func goToMainScreen() {
        let mainVC = ModelSelectionViewController()
        let nav = UINavigationController(rootViewController: mainVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}
