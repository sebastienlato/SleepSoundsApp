import SwiftUI

/// Displays a single ambient track with play toggle and contextual volume slider.
struct SoundCardView: View {
    let sound: SleepSound
    @ObservedObject var audioManager: AudioManager

    private var isPlaying: Bool {
        audioManager.isPlaying(sound.id)
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: sound.iconSystemName)
                    .font(.system(size: 32))
                    .foregroundStyle(sound.accentColor)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(sound.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(isPlaying ? "Playing" : "Tap play to begin")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    audioManager.toggleSound(sound.id)
                } label: {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(sound.accentColor)
                }
                .sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: isPlaying)
            }

            if isPlaying {
                VolumeSlider(sound: sound, audioManager: audioManager)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPlaying)
    }
}

/// Keeps slider logic separate so state changes animate cleanly.
private struct VolumeSlider: View {
    let sound: SleepSound
    @ObservedObject var audioManager: AudioManager

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "speaker.fill")
                .foregroundStyle(.secondary)
            Slider(
                value: Binding(
                    get: { audioManager.volume(for: sound.id) },
                    set: { audioManager.setVolume(for: sound.id, volume: $0) }
                ),
                in: 0...1
            )
            .tint(sound.accentColor)
            Image(systemName: "speaker.wave.3.fill")
                .foregroundStyle(.secondary)
        }
        .font(.caption)
    }
}

struct SoundCardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundCardView(
            sound: SleepSound.catalog.first!,
            audioManager: AudioManager()
        )
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
    }
}
