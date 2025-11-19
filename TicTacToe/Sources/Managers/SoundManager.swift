//
//  SoundManager.swift
//  TicTacToe
//
//  Created by Dmitry on 11/17/25.
//

import AVFoundation

final class SoundManager {
    
    // MARK: - Singleton
    static let shared = SoundManager()
    private init() {}
    
    // MARK: - Properties
    private var audioPlayer: AVAudioPlayer?
    
    /// Determines whether sounds are allowed to play.
    /// This value is persisted in UserDefaults and can be changed from the settings screen.
    var soundEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "soundEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "soundEnabled") }
    }
    
    private var preloadedPlayers: [String: AVAudioPlayer] = [:]
    
    // MARK: - Public API
    
    func play(_ name: String) {
        guard soundEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("Sound not found: \(name)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play sound \(name): \(error)")
        }
    }
    
    func preload(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            preloadedPlayers[name] = player
        } catch {
            print("Failed to preload sound \(name): \(error)")
        }
    }
}
