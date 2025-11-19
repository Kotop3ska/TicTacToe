//
//  SettingsViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/17/25.
//

import UIKit

final class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    private lazy var contentView = createContentView()

    private lazy var soundLabel = createLabel(text: .localized("sound_label"))

    private lazy var soundSwitch = createSoundSwitch()

    private lazy var languageLabel = createLabel(text: .localized("language_label"))

    private lazy var languagePicker = createLanguagePicker()

    private let languages = ["English": "en", "Русский": "ru"]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupContentView()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentLang = LanguageManager.shared.currentLanguage
        if let index = Array(languages.values).firstIndex(of: currentLang) {
            languagePicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        updateTexts()
    }

    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: contentView)
        return !contentView.bounds.contains(location)
    }

    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    private func setupContentView() {
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            contentView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        let soundStack = UIStackView(arrangedSubviews: [soundLabel, soundSwitch])
        soundStack.axis = .horizontal
        soundStack.distribution = .equalSpacing
        soundStack.spacing = 20
        soundStack.alignment = .center
        soundStack.translatesAutoresizingMaskIntoConstraints = false
        
        let languageStack = UIStackView(arrangedSubviews: [languageLabel, languagePicker])
        languageStack.axis = .horizontal
        languageStack.distribution = .equalSpacing
        languageStack.spacing = 20
        languageStack.alignment = .center
        languageStack.translatesAutoresizingMaskIntoConstraints = false
        languagePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        let verticalStack = UIStackView(arrangedSubviews: [soundStack, languageStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 20
        verticalStack.distribution = .fillEqually
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
    }
    
    private func setupActions() {
        soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
    }

    // MARK: - Actions
    @objc private func soundSwitchChanged() {
        SoundManager.shared.soundEnabled = soundSwitch.isOn
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    private func updateTexts() {
        soundLabel.text = .localized("sound_label")
        languageLabel.text = .localized("language_label")
    }
    
    // MARK: - Create UI
    private func createContentView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createSoundSwitch() -> UISwitch {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.isOn = SoundManager.shared.soundEnabled
        return sw
    }
    
    private func createLanguagePicker() -> UIPickerView {
        let picker = UIPickerView()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }
}

// MARK: - UIPickerViewDelegate & DataSource
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Array(languages.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCode = Array(languages.values)[row]
        LanguageManager.shared.currentLanguage = selectedCode
        updateTexts()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = Array(languages.keys)[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black 
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
