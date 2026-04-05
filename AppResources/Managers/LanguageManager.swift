//
//  LanguageManager.swift
//  TicTacToe
//
//  Created by Dmitry on 11/17/25.
//

import Foundation

// MARK: - LanguageManager

/// Manages the application's language settings and resource localization.
public final class LanguageManager {
    
    /// Singleton reference.
    public static let shared = LanguageManager()
    
    /// Prevents external initialization.
    private init() {}
    
    /// Key for storing the selected language in UserDefaults.
    private let selectedLanguageKey = "selectedLanguage"

    /// Gets or sets the current application language.
    /// - Get: Returns the saved language or the system default language code
    /// - Set: Saves the new language and notifies observers via NotificationCenter
    public var currentLanguage: String {
        get {
            if let saved = UserDefaults.standard.string(forKey: selectedLanguageKey) {
                return saved
            }
            return Locale.current.language.languageCode?.identifier ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selectedLanguageKey)
            
            NotificationCenter.default.post(
                name: NSNotification.Name("LanguageDidChange"),
                object: nil
            )
        }
    }
    
    /// Returns a framework bundle for loading localized resources.
    /// - Returns: Bundle associated with the LanguageManager class
    public static var frameworkBundle: Bundle {
        let baseBundle = Bundle(for: LanguageManager.self)
        let language = LanguageManager.shared.currentLanguage
        
        guard let path = baseBundle.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return baseBundle
        }
        
        return bundle
    }
}

// MARK: - Helper extension

public extension String {
    
    /// Returns a localized string from the framework bundle.
    /// - Parameters:
    ///   - key: String key in the localization file
    ///   - comment: Comment for the translator context
    /// - Returns: Localized string or key if no translation was found
    static func localized(_ key: String, comment: String = "") -> String {
    
        return NSLocalizedString(
            key,
            bundle: LanguageManager.frameworkBundle,
            comment: comment
        )
    }
}
