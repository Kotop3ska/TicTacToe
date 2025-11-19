//
//  LanguageManager.swift
//  TicTacToe
//
//  Created by Dmitry on 11/17/25.
//

import Foundation

extension String {
    static func localized(_ key: String) -> String {
        let lang = LanguageManager.shared.currentLanguage
        let path = Bundle.main.path(forResource: lang, ofType: "lproj") ?? ""
        let bundle = Bundle(path: path) ?? .main
        return NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
    }
}

final class LanguageManager {
    static let shared = LanguageManager()
    private init() {}

    private let selectedLanguageKey = "selectedLanguage"

    var currentLanguage: String {
        get {
            if let saved = UserDefaults.standard.string(forKey: selectedLanguageKey) {
                return saved
            }
            return Locale.current.language.languageCode?.identifier ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selectedLanguageKey)
        }
    }
}
