//
//  SoundManager.swift
//  TicTacToe
//
//  Created by Dmitry on 11/17/25.
//

import AVFoundation
import Foundation

/// Controls playback and preloading of sound effects.
public final class SoundManager {
    
    /// Singleton reference.
    public static let shared = SoundManager()
    
    /// Prevents external initializing.
    private init() {}
    
    // MARK: - Properties
    
    /// Active audio player for playback.
    private var audioPlayer: AVAudioPlayer?
    
    /// Determines whether sounds are allowed to play.
    /// - Get: Returns a value from UserDefaults
    /// - Set: Saves a new value to UserDefaults
    public var soundEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "soundEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "soundEnabled") }
    }
    
    /// Caches preloaded audio players by sound name.
    private var preloadedPlayers: [String: AVAudioPlayer] = [:]
    
    /// Resource bundle for loading audio files.
    private let resourceBundle: Bundle = {
        return Bundle(for: SoundManager.self)
    }()
    
    // MARK: - Public methods
    
    /// Plays a sound file from the "SoundResources" subdirectory.
    /// - Parameters:
    ///   - name: File name without extension
    ///   - extension: File extension (default "wav")
    public func play(_ name: String, extension: String? = "wav") {
        
        guard soundEnabled else { return }
        
        guard let url = resourceBundle.url(forResource: name,
                                           withExtension: `extension`,
                                           subdirectory: "SoundResources") else {
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
    
    /// Preloads a sound file into memory for instant playback.
    /// - Parameters:
    ///   - name: File name without extension
    ///   - extension: File extension (default "wav")
    public func preload(_ name: String, extension: String? = "wav") {

        guard let url = resourceBundle.url(forResource: name,
                                           withExtension: `extension`,
                                           subdirectory: "SoundResources") else {
            print("Sound not found for preload: \(name)")
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            preloadedPlayers[name] = player
        } catch {
            print("Failed to preload sound \(name): \(error)")
        }
    }
    
    /// Clears the cache of preloaded sounds.
    public func clearPreloaded() {
        preloadedPlayers.removeAll()
    }
}
