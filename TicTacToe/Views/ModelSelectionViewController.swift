//
//  ModelSelectionViewController.swift
//  
//
//  Created by Dmitry on 11/4/25.
//

import UIKit

final class ModelSelectionViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var onePlayerButton = createButton(leftIcon: "gamecontroller.fill", rightIcon: "person.fill")
    private lazy var twoPlayerButton = createButton(leftIcon: "person.fill", rightIcon: "person.fill")
    private lazy var iconImageView = createImageView(name: "MainLogo")
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        setupUI()
        setupActions()
        setupNavigationItem()
        
    }
    
   // MARK: - Setup Methods
    
    /// Sets up UI elements and layout constraints
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, onePlayerButton, twoPlayerButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            {
                let centerY = stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
                centerY.priority = .defaultLow
                return centerY
            }(),

            
            iconImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
                    
            onePlayerButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            onePlayerButton.heightAnchor.constraint(equalToConstant: 60),
                    
            twoPlayerButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            twoPlayerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    /// Sets up settings button in right corner
    private func setupNavigationItem() {
        let settingsImage = UIImage(systemName: "gearshape.fill")
        let settingsButton = UIBarButtonItem(image: settingsImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsTapped))
        settingsButton.tintColor = .black
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    /// Adds button actions for tapping events
    private func setupActions() {
        onePlayerButton.addTarget(self, action: #selector(onePlayerTapped), for: .touchUpInside)
        twoPlayerButton.addTarget(self, action: #selector(twoPlayerTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    /// Pushes EnterOneNameViewController when 1-player button tapped
    @objc private func onePlayerTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let enterNamesVC = EnterOneNameViewController()
        navigationController?.pushViewController(enterNamesVC, animated: true)
    }
    
    /// Pushes EnterTwoNamesViewController when 2-player button tapped
    @objc private func twoPlayerTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let enterNamesVC = EnterTwoNamesViewController()
        navigationController?.pushViewController(enterNamesVC, animated: true)
    }
    
    /// Opens settings window
    @objc private func settingsTapped() {
        SoundManager.shared.play("buttonTapSound.wav")
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .overCurrentContext
        settingsVC.modalTransitionStyle = .crossDissolve
        present(settingsVC, animated: true)
    }
    
    // MARK: - Create Elements
    
    /// Creates a UIButton with optional left and right icons
    private func createButton(leftIcon: String?, rightIcon: String?, text: String = "VS") -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .playerOColor
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceLeftToRight
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        
        let attributedString = NSMutableAttributedString()
        
        if let leftIcon = leftIcon, let attachment = createAttachment(imageName: leftIcon) {
            attributedString.append(NSAttributedString(attachment: attachment))
            attributedString.append(NSAttributedString(string: "    "))
        }
        
        attributedString.append(NSAttributedString(string: text))
        attributedString.append(NSAttributedString(string: "    "))
        
        if let rightIcon = rightIcon, let attachment = createAttachment(imageName: rightIcon) {
            attributedString.append(NSAttributedString(attachment: attachment))
        }
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }
    
    /// Creates a UIImageView with the given image name
    private func createImageView(name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    /// Creates an NSTextAttachment for button icons
    private func createAttachment(imageName: String) -> NSTextAttachment? {
        guard let image = UIImage(systemName: imageName)?.withTintColor(.white) else { return nil }
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -4, width: image.size.width * 1.7, height: image.size.height * 1.7)
        return attachment
    }
}
