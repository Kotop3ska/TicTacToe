//
//  SettingsViewController.swift
//  TicTacToe
//
//  Created by Dmitry on 11/17/25.
//

import UIKit
import UIElementsBuilders
import AppResources

/// Presents a modal settings screen for configuring sound and language preferences.
final class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    
    /// Container view for settings content with rounded corners.
    private lazy var contentView = createContentView()

    /// Label for the sound toggle option.
    private lazy var soundLabel = createLabel(text: .localized("sound_label"), color: .black, fontSize: 18)

    /// Switch to enable/disable sound effects.
    private lazy var soundSwitch = createSoundSwitch()
    
    /// Label for the language selection option.
    private lazy var languageLabel = createLabel(text: .localized("language_label"), color: .black, fontSize: 18)

    /// Picker to select application language.
    private lazy var languagePicker = createLanguagePicker()
   
    /// Maps language display names to locale codes.
    private let languages = ["English": "en", "Русский": "ru"]
    
    /// Provides access to UI component builders.
    private let elementsBuilder = UIBuilder.shared

    // MARK: - Life cycle
    
    /// Configures background, content view, and event handlers.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupContentView()
        setupActions()
    }
    
    /// Syncs UI with current language and sound settings.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentLang = LanguageManager.shared.currentLanguage
        if let index = Array(languages.values).firstIndex(of: currentLang) {
            languagePicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        updateTexts()
    }

    // MARK: - UIGestureRecognizerDelegate
    
    /// Allows tap gesture to dismiss only when touching outside content view.
    /// - Parameters:
    ///   - gestureRecognizer: The gesture recognizer
    ///   - touch: The touch location
    /// - Returns: `true` if touch is outside contentView bounds
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: contentView)
        return !contentView.bounds.contains(location)
    }

    // MARK: - Setup UI
    
    /// Configures semi-transparent background and tap-to-dismiss gesture.
    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    /// Builds and constrains the settings content view with stacked options.
    private func setupContentView() {
        self.setupContentViewConstraints()
            
        let soundStack = self.createSoundStack()
        let languageStack = self.createLanguageStack()
        let verticalStack = self.createVerticalStack(soundStack: soundStack, languageStack: languageStack)
        
        self.contentView.addSubview(verticalStack)
        self.setupVerticalStackConstraints(verticalStack: verticalStack)
        self.setupLanguagePickerDelegates()
    }
    
    /// Pins the content view to the center of the screen with fixed dimensions.
    private func setupContentViewConstraints() {
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.contentView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    /// Creates a horizontal stack with sound label and switch.
    /// - Returns: Configured UIStackView
    private func createSoundStack() -> UIStackView {
        let stack = self.elementsBuilder.stackBuilder.createHorizontalStackView(with: 20,
                                                                                distribution: .equalSpacing,
                                                                                alignment: .center)
        stack.addArrangedSubview(self.soundLabel)
        stack.addArrangedSubview(self.soundSwitch)
        return stack
    }
    
    /// Creates a horizontal stack with language label and picker.
    /// - Returns: Configured UIStackView with fixed picker width
    private func createLanguageStack() -> UIStackView {
        let stack = self.elementsBuilder.stackBuilder.createHorizontalStackView(with: 20,
                                                                                distribution: .equalSpacing,
                                                                                alignment: .center)
        stack.addArrangedSubview(self.languageLabel)
        stack.addArrangedSubview(self.languagePicker)
        self.languagePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return stack
    }
    
    /// Creates a vertical stack containing sound and language option stacks.
    /// - Parameters:
    ///   - soundStack: Horizontal stack for sound toggle
    ///   - languageStack: Horizontal stack for language picker
    /// - Returns: Configured vertical UIStackView
    private func createVerticalStack(soundStack: UIStackView, languageStack: UIStackView) -> UIStackView {
        let stack = self.elementsBuilder.stackBuilder.createVerticalStackView(with: 20, distribution: .fillEqually, alignment: .fill)
        stack.addArrangedSubview(soundStack)
        stack.addArrangedSubview(languageStack)

        return stack
    }
    
    /// Constrains the vertical stack to the content view with padding.
    /// - Parameter verticalStack: Target UIStackView
    private func setupVerticalStackConstraints(verticalStack: UIStackView) {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40),
            verticalStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 40),
            verticalStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40),
            verticalStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -40)
        ])
    }
    
    /// Assigns delegate and data source to the language picker.
    private func setupLanguagePickerDelegates() {
        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self
    }
    
    /// Connects valueChanged action to the sound switch.
    private func setupActions() {
        soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
    }

    // MARK: - Actions
    
    /// Updates SoundManager setting when switch value changes.
    @objc private func soundSwitchChanged() {
        SoundManager.shared.soundEnabled = soundSwitch.isOn
    }

    /// Dismisses the modal settings screen.
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    
    /// Refreshes localized text for labels.
    private func updateTexts() {
        soundLabel.text = .localized("sound_label")
        languageLabel.text = .localized("language_label")
    }
    
    // MARK: - Create UI
    
    /// Creates a rounded white container view for settings content.
    /// - Returns: Configured UIView with corner radius and Auto Layout support
    private func createContentView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    /// Creates a configured UILabel via the builder.
    /// - Parameters:
    ///   - text: Label text
    ///   - color: Text color
    ///   - fontSize: Font size
    /// - Returns: Configured UILabel instance
    private func createLabel(text: String, color: UIColor, fontSize: CGFloat) -> UILabel {
        return self.elementsBuilder.labelBuilder.createLabel(text: text, color: color, fontSize: fontSize)
    }
    
    /// Creates a UISwitch synced with current SoundManager setting.
    /// - Returns: Configured UISwitch instance
    private func createSoundSwitch() -> UISwitch {
        let sw = self.elementsBuilder.switchBuilder.createSwitch()
        sw.isOn = SoundManager.shared.soundEnabled
        return sw
    }
    
    /// Creates a basic UIPickerView via the builder.
    /// - Returns: Configured UIPickerView instance
    private func createLanguagePicker() -> UIPickerView {
        return self.elementsBuilder.pickerBuilder.createPicker()
    }
}

// MARK: - UIPickerViewDelegate & DataSource

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// Returns the number of picker components (1 for language list).
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    /// Returns the number of available languages.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        languages.count
    }
    
    /// Returns the display name for a language row.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Array(languages.keys)[row]
    }
    
    /// Updates LanguageManager and UI when a language is selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCode = Array(languages.values)[row]
        LanguageManager.shared.currentLanguage = selectedCode
        updateTexts()
    }
    
    /// Returns an attributed title with black foreground color for picker rows.
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = Array(languages.keys)[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black 
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
