import SwiftUI

struct SoundboardView: View {
    @StateObject private var audioManager: AudioManager
    @StateObject private var timerManager: SleepTimerManager
    @State private var isTimerSheetPresented = false

    init() {
        let audioManager = AudioManager()
        _audioManager = StateObject(wrappedValue: audioManager)
        _timerManager = StateObject(wrappedValue: SleepTimerManager(audioManager: audioManager))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    if let remaining = timerManager.formattedRemaining {
                        ActiveSleepTimerBanner(
                            remainingText: remaining,
                            cancelAction: timerManager.cancel
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    ForEach(audioManager.sounds) { sound in
                        SoundCardView(sound: sound, audioManager: audioManager)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 24)
            }
            .navigationTitle("Sleep Sounds")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isTimerSheetPresented = true
                    } label: {
                        Image(systemName: timerManager.isActive ? "timer.square" : "clock")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .accessibilityLabel(timerManager.isActive ? "Edit sleep timer" : "Set sleep timer")
                }
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .sheet(isPresented: $isTimerSheetPresented) {
                SleepTimerSheet(timerManager: timerManager)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

private struct ActiveSleepTimerBanner: View {
    let remainingText: String
    let cancelAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "timer")
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 2) {
                Text("Sleep timer active")
                    .font(.subheadline.weight(.semibold))
                Text("Sound stops in \(remainingText)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(role: .cancel, action: cancelAction) {
                Text("Cancel")
                    .font(.footnote.weight(.semibold))
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct SoundboardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundboardView()
    }
}
