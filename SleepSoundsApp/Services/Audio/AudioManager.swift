import AVFAudio
import Combine
import Foundation
import UIKit

@MainActor
final class AudioManager: ObservableObject {
    @Published private(set) var playingSoundIDs: Set<String> = []
    @Published private var volumes: [String: Double] = [:]

    private var players: [String: AVAudioPlayer] = [:]
    private var cancellables: Set<AnyCancellable> = []

    let sounds: [SleepSound]

    init(sounds: [SleepSound]? = nil) {
        self.sounds = sounds ?? SleepSound.catalog
        self.sounds.forEach { sound in
            volumes[sound.id] = sound.defaultVolume
        }
        configureAudioSession()
        observeAudioSession()
    }

    func playSound(_ id: String) {
        guard players[id] == nil else {
            players[id]?.play()
            playingSoundIDs.insert(id)
            return
        }

        guard let sound = sounds.first(where: { $0.id == id }) else { return }
        activateSessionIfNeeded()
        guard let asset = NSDataAsset(name: sound.assetName) else {
            assertionFailure("Missing audio asset named \(sound.assetName)")
            return
        }

        do {
            let player = try AVAudioPlayer(data: asset.data)
            player.numberOfLoops = -1
            player.volume = Float(volume(for: id))
            player.prepareToPlay()
            player.play()

            players[id] = player
            playingSoundIDs.insert(id)
        } catch {
            print("Failed to start audio for \(sound.name): \(error)")
        }
    }

    func stopSound(_ id: String) {
        players[id]?.stop()
        players.removeValue(forKey: id)
        playingSoundIDs.remove(id)
    }

    func toggleSound(_ id: String) {
        if playingSoundIDs.contains(id) {
            stopSound(id)
        } else {
            playSound(id)
        }
    }

    func setVolume(for id: String, volume: Double) {
        volumes[id] = volume
        players[id]?.volume = Float(volume)
    }

    func volume(for id: String) -> Double {
        volumes[id] ?? 0.5
    }

    func isPlaying(_ id: String) -> Bool {
        playingSoundIDs.contains(id)
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true, options: [])
        } catch {
            print("Audio session configuration failed: \(error)")
        }
    }

    private func activateSessionIfNeeded() {
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            print("Failed to activate audio session: \(error)")
        }
    }

    private func observeAudioSession() {
        NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                guard let self else { return }
                Task { @MainActor in
                    self.handleInterruption(notification)
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: AVAudioSession.mediaServicesWereResetNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task { @MainActor in
                    self.recoverFromServiceReset()
                }
            }
            .store(in: &cancellables)
    }

    private func handleInterruption(_ notification: Notification) {
        guard
            let info = notification.userInfo,
            let rawType = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: rawType)
        else { return }

        switch type {
        case .began:
            players.values.forEach { $0.pause() }
        case .ended:
            activateSessionIfNeeded()
            players.values.forEach { player in
                player.play()
            }
        @unknown default:
            break
        }
    }

    private func recoverFromServiceReset() {
        let activeIDs = playingSoundIDs
        players.removeAll()
        configureAudioSession()
        activeIDs.forEach { id in
            playSound(id)
        }
    }
}
