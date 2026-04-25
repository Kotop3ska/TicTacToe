//
//  SplashViewControllerViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/5/25.
//

import UIKit
import UIElementsFactory
import AppResources

/// Displays the app launch screen with logo animation before transitioning to the main menu.
class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The logo image.
    private lazy var logoImageView = createImageView(name: "LoadLogo")
    
    /// Provides access to UI component factory.
    private let elementsFactory = UIFactory.shared
    
    // MARK: - Life cycle
    
    /// Configures the UI layout and appearance.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    /// Triggers the logo animation after the view appears.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
    }
    
    // MARK: - Setup UI
    
    /// Configures background color, adds logo, and sets up constraints.
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)

        setupConstraints()
    }
    
    /// Centers the logo image with fixed 200x200 dimensions.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Main methods
    
    /// Animates logo scale and fade-in, then transitions to main screen.
    private func animateLogo() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        logoImageView.alpha = 0.0
        DispatchQueue.main.async {
            SoundManager.shared.play("startGameSound")
        }
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseOut) {
            self.logoImageView.transform = .identity
            self.logoImageView.alpha = 1.0
        } completion: { _ in
            self.goToMainScreen()
        }
    }
    
    /// Presents the main menu screen wrapped in a navigation controller.
    private func goToMainScreen() {
        let mainVC = ModelSelectionViewController()
        let nav = UINavigationController(rootViewController: mainVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    /// Creates a UIImageView with the specified image name via builder.
    /// - Parameter name: Image name in asset catalog
    /// - Returns: Configured UIImageView instance
    private func createImageView(name: String) -> UIImageView {
        return self.elementsFactory.imageViewBuilder.createImageView(name: name)
    }
}
