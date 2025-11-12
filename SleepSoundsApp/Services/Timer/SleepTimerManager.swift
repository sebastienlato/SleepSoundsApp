import Combine
import Foundation

/// Counts down in one-second ticks and stops audio playback once the timer elapses.
@MainActor
final class SleepTimerManager: ObservableObject {
    @Published private(set) var remainingTime: TimeInterval?

    var isActive: Bool {
        remainingTime != nil
    }

    var formattedRemaining: String? {
        guard let remainingTime else { return nil }
        return Self.formatter.string(from: remainingTime)
    }

    private weak var audioManager: AudioManager?
    private var timer: Timer?

    init(audioManager: AudioManager) {
        self.audioManager = audioManager
    }

    deinit {
        timer?.invalidate()
    }

    func start(duration: TimeInterval) {
        guard duration > 0 else { return }
        timer?.invalidate()
        remainingTime = duration
        scheduleTimer()
    }

    func cancel() {
        timer?.invalidate()
        timer = nil
        remainingTime = nil
    }

    private func scheduleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            Task { @MainActor [weak self] in
                self?.tick()
            }
        }

        guard let timer else { return }
        RunLoop.main.add(timer, forMode: .common)
        timer.tolerance = 0.2
    }

    private func tick() {
        guard let remainingTime else {
            cancel()
            return
        }

        let nextValue = max(remainingTime - 1, 0)
        if nextValue <= 0 {
            completeTimer()
        } else {
            self.remainingTime = nextValue
        }
    }

    private func completeTimer() {
        cancel()
        audioManager?.stopAllSounds()
    }

    private static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
}
